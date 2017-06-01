{-# LANGUAGE ForeignFunctionInterface #-}

module System.Breakpoint
    ( breakOnEval
    , breakpoint
    ) where

import System.IO.Unsafe

foreign import ccall unsafe "c_breakpoint" breakpoint :: IO ()

breakOnEval :: a -> a
breakOnEval x = unsafePerformIO $ do
    breakpoint
    return x
