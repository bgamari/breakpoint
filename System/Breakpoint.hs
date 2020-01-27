{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE MagicHash #-}
{-# LANGUAGE UnboxedTuples #-}

module System.Breakpoint
    ( breakOnEval
    , breakpoint
    , breakpoint'
    , logWord
    , logPointer
    , logThreadId
    ) where

import System.IO.Unsafe
import Foreign.C.String
import GHC.IO
import GHC.Word
import GHC.Int
import GHC.Prim

foreign import ccall unsafe "c_breakpoint" breakpoint' :: CString -> IO ()

breakpoint :: String -> IO ()
breakpoint lbl = withCString lbl breakpoint'

breakOnEval :: String -> a -> a
breakOnEval lbl x = unsafePerformIO $ do
    breakpoint lbl
    return $!x

logString :: String -> IO ()
logString s = withCString s logString'

logPointer :: a -> IO ()
logPointer x = do
    a <- IO $ \s -> case anyToAddr# x s of (# s', addr #) -> (# s', fromIntegral (I# (addr2Int# addr)) #)
    logWord a

foreign import ccall unsafe "c_log_tid" logThreadId :: IO ()
foreign import ccall unsafe "c_log_word" logWord :: Word -> IO ()
foreign import ccall unsafe "c_log_string" logString' :: CString -> IO ()
