public class Class {}  // Should warn; neither open nor final.

open class Open {}  // Should not warn; open.

public final class Final {}  // Should not warn; final.

internal class Internal {}  // Should not warn; compiler can infer finality.
class ImplicitInternal {}  // Should not warn; compiler can infer finality.
