package funkin_haxe.std;

import thx.ReadonlyArray;

class Arrays {
	/**
		Filters out all `null` values from an array.
	**/
	public static function filterNull<T>(a:ReadonlyArray<Null<T>>):Array<T> {
		var arr:Array<T> = [];
		for (v in a)
			if (null != v)
				arr.push(v);
		return arr;
	}
}