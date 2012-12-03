package com.obscure.ticarousel;

import org.appcelerator.titanium.proxy.TiViewProxy;
import org.appcelerator.titanium.view.TiCompositeLayout;
import org.appcelerator.titanium.view.TiUIView;

public class TiCarouselView extends TiUIView {

	public TiCarouselView(TiViewProxy proxy) {
		super(proxy);
		TiCompositeLayout view = new TiCompositeLayout(proxy.getActivity());
		setNativeView(view); // TODO
	}

}
