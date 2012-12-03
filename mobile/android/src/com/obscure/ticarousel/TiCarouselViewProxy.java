package com.obscure.ticarousel;

import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.titanium.proxy.TiViewProxy;
import org.appcelerator.titanium.view.TiUIView;

import android.app.Activity;

@Kroll.proxy(creatableInModule = TiCarouselModule.class)
public class TiCarouselViewProxy extends TiViewProxy {

	@Override
	public TiUIView createView(Activity activity) {
		TiCarouselView view = new TiCarouselView(this);
		return view;
	}

}
