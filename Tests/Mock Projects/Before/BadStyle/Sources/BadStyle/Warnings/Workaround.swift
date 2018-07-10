// Header

// #workaround(Dependency 0.9.9, This should trigger. The workaround may no longer be necessary.)
// #workaround(Dependency 1.0.0, This should be silent. The workaround is still necessary.)

// #workaround(Swift 3, This should trigger. The workaround may no longer be necessary.)
// #workaround(Swift 100, This should be silent. The workaround is still necessary.)

// #workaround(echo 1.0.0 0.9.9, This should trigger. The workaround may no longer be necessary.)
// #workaround(echo 1.0.0 1.0.0, This should be silent. The workaround is still necessary.)

// #workaround(This should trigger no matter what.)
// #workaround(echo oops 1.0.0, This malformed version check should trigger.)
