{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE MagicHash #-}
{-# LANGUAGE UnboxedTuples #-}

module System.Breakpoint
    ( breakOnEval
    , breakpoint
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

foreign import ccall unsafe "c_breakpoint" breakpoint :: CString -> IO ()

breakOnEval :: String -> a -> a
breakOnEval lbl x = unsafePerformIO . withCString lbl $ \clbl -> do
    breakpoint clbl
    return x

logPointer :: a -> IO ()
logPointer x = do
    a <- IO $ \s -> case anyToAddr# x s of (# s', addr #) -> (# s', fromIntegral (I# (addr2Int# addr)) #)
    logWord a

foreign import ccall unsafe "c_log_tid" logThreadId :: IO ()
foreign import ccall unsafe "c_log_word" logWord :: Word -> IO ()
