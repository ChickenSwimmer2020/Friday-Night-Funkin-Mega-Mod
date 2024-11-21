package funkin_haxe.std;

class FunkinArray {
    /**
     * This will clear all objects in `a`.
     * 
     * Modifies `a` array in place and returns it.
     * 
     * If `a` is null, an empty array will be returned.
     * @param a Array you would like to clear.
     * @return Array<T> Returning array.
     */
    public static function clear<T>(a:Array<T>):Array<T> {
        if (a != null) {
            for (o in a)
                a.remove(o);
            return a;
        }
        return [];
    }
}