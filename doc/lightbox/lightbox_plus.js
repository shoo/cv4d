// lightbox_plus.js
// == written by Takuya Otani <takuya.otani@gmail.com> ===
// == Copyright (C) 2006 SimpleBoxes/SerendipityNZ Ltd. ==
/*
	Copyright (C) 2006 Takuya Otani/SimpleBoxes - http://serennz.cool.ne.jp/sb/
	Copyright (C) 2006 SerendipityNZ - http://serennz.cool.ne.jp/snz/
	
	This script is licensed under the Creative Commons Attribution 2.5 License
	http://creativecommons.org/licenses/by/2.5/
	
	basically, do anything you want, just leave my name and link.
*/
/*
	Original script : Lightbox JS : Fullsize Image Overlays
	Copyright (C) 2005 Lokesh Dhakar - http://www.huddletogether.com
	For more information on this script, visit:
	http://huddletogether.com/projects/lightbox/
*/
// ver. 20100823 - fixed a bug ( some captions could be shown on out side of screen )
// ver. 20100821 - fixed a bug ( missing action buttons in some occasions )
// ver. 20090729 - fixed a bug ( lightbox may not be closed properly )
// ver. 20090709 - fixed a bug ( loading image is not shown properly )
// ver. 20090707 - implemented animation feature
// ver. 20090318 - fixed a bug ( prev/next are not shown in some occasions )
// ver. 20061027 - fixed a bug ( not work at xhtml documents on Netscape7 )
// ver. 20061026 - fixed bugs
// ver. 20061010 - implemented image set feature
// ver. 20060921 - fixed a bug / added overall view
// ver. 20060920 - added flag to prevent mouse wheel event
// ver. 20060919 - fixed a bug
// ver. 20060918 - implemented functionality of wheel zoom & drag'n drop
// ver. 20060131 - fixed a bug to work correctly on Internet Explorer for Windows
// ver. 20060128 - implemented functionality of echoic word
// ver. 20060120 - implemented functionality of caption and close button
// === elements ===
document.getElemetsByClassName = function(name,target)
{
	var result = [];
	var object  = null;
	var search = new RegExp(['(^|\\s)',name,'(\\s|$)'].join(''));
	if (target && target.getElementsByTagName)
		object = target.getElementsByTagName('*');
	if (!object)
		object = document.getElementsByTagName ? document.getElementsByTagName('*') : document.all;
	for (var i=0,n=object.length;i<n;i++)
	{
		var check = object[i].getAttribute('class') || object[i].className;
		if (check.match(search)) result.push(object[i]);
	}
	return result;
}
// === window ===
function WindowSize()
{ // window size object
	this.w = 0;
	this.h = 0;
	return this;
}
WindowSize.prototype.update = function()
{
	var d = document;
	var w = 
	  (window.innerWidth) ? window.innerWidth
	: (d.documentElement && d.documentElement.clientWidth) ? d.documentElement.clientWidth
	: d.body.clientWidth;
	var h = 
	  (window.innerHeight) ? window.innerHeight
	: (d.documentElement && d.documentElement.clientHeight) ? d.documentElement.clientHeight
	: d.body.clientHeight;
	if (w != this.w || h != this.h)
	{
		this.w = w;
		this.h = h;
		return true;
	}
	return false;
};
function PageSize()
{ // page size object
	this.win = new WindowSize();
	this.w = 0;
	this.h = 0;
	return this;
}
PageSize.prototype.update = function()
{
	var d = document;
	var w = 
	  (window.innerWidth && window.scrollMaxX) ? window.innerWidth + window.scrollMaxX
	: (d.body.scrollWidth > d.body.offsetWidth) ? d.body.scrollWidth
	: d.body.offsetWidt;
	var h = 
	  (window.innerHeight && window.scrollMaxY) ? window.innerHeight + window.scrollMaxY
	: (d.body.scrollHeight > d.body.offsetHeight) ? d.body.scrollHeight
	: d.body.offsetHeight;
	var updated = this.win.update();
	if (w < this.win.w) w = this.win.w;
	if (h < this.win.h) h = this.win.h;
	if (updated || w != this.w || h != this.h)
	{
		this.w = w;
		this.h = h;
		return true;
	}
	return false;
};
function PagePos()
{ // page position object
	this.x = 0;
	this.y = 0;
	return this;
}
PagePos.prototype.update = function()
{
	var d = document;
	var x =
	  (window.pageXOffset) ? window.pageXOffset
	: (d.documentElement && d.documentElement.scrollLeft) ? d.documentElement.scrollLeft
	: (d.body) ? d.body.scrollLeft
	: 0;
	var y =
	  (window.pageYOffset) ? window.pageYOffset
	: (d.documentElement && d.documentElement.scrollTop) ? d.documentElement.scrollTop
	: (d.body) ? d.body.scrollTop
	: 0;
	if (x != this.x || y != this.y)
	{
		this.x = x;
		this.y = y;
		return true;
	}
	return false;
};
// === browser ===
if ( !window.Spica )
{
	var Spica = {};
	Spica.Browser = new function()
	{
		this.name = navigator.userAgent;
		this.isWinIE = this.isMacIE = false;
		this.isGecko = this.name.match(/Gecko\//);
		this.isSafari = this.name.match(/AppleWebKit/);
		this.isSafari3 = (this.name.match(/AppleWebKit\/(\d\d\d)/) && parseInt(RegExp.$1) > 500);
		this.isKHTML = this.isSafari || navigator.appVersion.match(/Konqueror|KHTML/);
		this.isOpera = window.opera;
		if (document.all && !this.isGecko && !this.isSafari && !this.isOpera)
		{
			this.isWinIE = this.name.match(/Win/);
			this.isMacIE = this.name.match(/Mac/);
			this.isNewIE = (this.name.match(/MSIE (\d\.\d)/) && RegExp.$1 > 6.5);
		}
	};
	Spica.Event = {
		cache : false,
		getEvent : function(evnt)
		{
			return (evnt) ? evnt : ((window.event) ? window.event : null);
		},
		getKey : function(evnt)
		{
			if (!evnt) return; // do nothing
			return (evnt.keyCode) ? evnt.keyCode : evnt.charCode;
		},
		stop : function(evnt)
		{
			if (!evnt) return; // do nothing
			try
			{
				evnt.stopPropagation();
			}
			catch(err) {};
			evnt.cancelBubble = true;
			try
			{
				evnt.preventDefault();
			}
			catch(err) {};
			return (evnt.returnValue = false);
		},
		register : function(object, type, handler)
		{
			if (!object) return;
			if (type == 'keypress' && !object.addEventListener) type = 'keydown';
			if (type == 'mousewheel' && Spica.Browser.isGecko) type = 'DOMMouseScroll';
			if (!this.cache) this.cache = [];
			if (object.addEventListener)
			{
				this.cache.push([object,type,handler]);
				object.addEventListener(type, handler, false);
			}
			else if (object.attachEvent)
			{
				this.cache.push([object,type,handler]);
				object.attachEvent('on' + type,handler);
			}
			else
			{
				object['on' + type] = handler;
			}
		},
		deregister : function(object, type, handler)
		{
			if (!object) return;
			if (type == 'keypress' && !object.addEventListener) type = 'keydown';
			if (type == 'mousewheel' && Spica.Browser.isGecko) type = 'DOMMouseScroll';
			if (object.removeEventListener)
				object.removeEventListener(type, handler, false);
			else if (object.detachEvent)
				object.detachEvent('on' + type, handler);
			else
				object['on' + type] = null;
		},
		deregisterAll : function()
		{
			if (!Spica.Event.cache) return
			for (var i=0,n=Spica.Event.cache.length;i<n;i++)
			{
				Spica.Event.deregister(Spica.Event.cache[i]);
				Spica.Event.cache[i][0] = null;
			}
			Spica.Event.cache = false;
		},
		run : function(func)
		{
			if (typeof func != 'function') return;
			(Spica.Browser.isGecko || Spica.Browser.isOpera)
				? this.register(window,'DOMContentLoaded',func)
				: this.register(window,'load',func);
		}
	};
	Spica.Event.register(window, 'unload', Spica.Event.deregisterAll);
} // end of if ( !window.Spica )
// === lightbox ===
function Lightbox(option)
{
	var self = this;
	self._imgs = new Array();
	self._sets = new Array();
	self._wrap = null;
	self._box  = null;
	self._img  = null;
	self._open = -1;
	self._page = new PageSize();
	self._pos  = new PagePos();
	self._zoomimg = null;
	self._expandable = false;
	self._expanded = false;
	self._funcs = {'move':null,'up':null,'drag':null,'wheel':null,'dbl':null};
	self._level = 1;
	self._curpos = {x:0,y:0};
	self._imgpos = {x:0,y:0};
	self._minpos = {x:0,y:0};
	self._expand = option.expandimg;
	self._shrink = option.shrinkimg;
	self._blank = option.blankimg;
	self._resizable = option.resizable;
	self._timer = null;
	self._anim = {step:0, w:50, h:50, a:0, t:0, f:option.animation};
	self._indicator = null;
	self._overall = null;
	self._openedset = null;
	self._prev = null;
	self._next = null;
	self._hiding = [];
	self._first = false;
	self._changed = false;
	self._actionEnabled = false;
	return self._init(option);
}
Lightbox.prototype = {
	refresh : function(target)
	{
		if (!target) target = document;
		this._imgs.length = 0;
		this._genListFromLinks(target);
	},
	_init : function(option)
	{
		var self = this;
		var d = document;
		if (!d.getElementsByTagName) return;
		if (Spica.Browser.isMacIE) return self;
		var body = d.getElementsByTagName("body")[0];
		self._wrap = self._createWrapOn(body);
		self._box  = self._createBoxOn(body,option);
		self._img  = self._box.firstChild;
		self._zoomimg = d.getElementById('actionImage');
		if ( !option.skipInit ) self._genListFromLinks(d);
		return self;
	},
	_genListFromLinks : function(d)
	{
		var self = this;
		var links = d.getElementsByTagName("a");
		for (var i=0;i<links.length;i++)
		{
			var anchor = links[i];
			var num = self._imgs.length;
			var rel = String(anchor.getAttribute("rel")).toLowerCase();
			if (!anchor.getAttribute("href") || !rel.match('lightbox')) continue;
			// initialize item
			self._imgs[num] = {
				src:anchor.getAttribute("href"),
				w:-1,
				h:-1,
				title:'',
				cls:anchor.className,
				set:rel
			};
			if (anchor.getAttribute("title"))
				self._imgs[num].title = anchor.getAttribute("title");
			else if ( anchor.firstChild 
			       && anchor.firstChild.getAttribute 
			       && anchor.firstChild.getAttribute("title"))
				self._imgs[num].title = anchor.firstChild.getAttribute("title");
			anchor.onclick = self._genOpener(num); // set closure to onclick event
			if (rel != 'lightbox')
			{
				if (!self._sets[rel]) self._sets[rel] = new Array();
				self._sets[rel].push(num);
			}
		}
	},
	_genOpener : function(num)
	{
		var self = this;
		return function() { self._show(num); return false; }
	},
	_createWrapOn : function(obj)
	{
		var self = this;
		if (!obj) return null;
		// create wrapper object, translucent background
		var wrap = document.createElement('div');
		obj.appendChild(wrap);
		wrap.id = 'overlay';
		wrap.style.display = 'none';
		wrap.style.position = 'fixed';
		wrap.style.top = '0px';
		wrap.style.left = '0px';
		wrap.style.zIndex = '50';
		wrap.style.width = '100%';
		wrap.style.height = '100%';
		if (Spica.Browser.isWinIE) wrap.style.position = 'absolute';
		Spica.Event.register(wrap,"click",function(evt) { self._close(evt); });
		return wrap;
	},
	_createBoxOn : function(obj,option)
	{
		var self = this;
		if (!obj) return null;
		// create lightbox object, frame rectangle
		var box = document.createElement('div');
		obj.appendChild(box);
		box.id = 'lightbox';
		box.style.display = 'none';
		box.style.position = 'absolute';
		box.style.zIndex = '60';
		// create image object to display a target image
		var img = document.createElement('img');
		box.appendChild(img);
		img.id = 'lightboxImage';
		img.width = 200;
		img.height = 200;
		self._set_cursor(img);
		Spica.Event.register(img,'mouseover',function() { self._actionEnabled = true; self._show_action(); });
		Spica.Event.register(img,'mouseout',function() { self._actionEnabled = false; self._hide_action(); });
		Spica.Event.register(img,'click',function(evt) { self._close(evt); });
		// create loading image, animated image
		var imag = new Image;
		imag.onload = function() {
			var spin = document.createElement('img');
			box.appendChild(spin);
			spin.id = 'loadingImage';
			spin.src = imag.src;
			spin.style.position = 'absolute';
			spin.style.zIndex = '70';
			self._set_cursor(spin);
			Spica.Event.register(spin,'click',function(evt) { self._close(evt); });
			imag.onload = function(){};
		};
		if (option.loadingimg != '') imag.src = option.loadingimg;
		// create hover navi - prev
		if (option.previmg)
		{
			var prevLink = document.createElement('img');
			box.appendChild(prevLink);
			prevLink.id = 'prevLink';
			prevLink.style.display = 'none';
			prevLink.style.position = 'absolute';
			prevLink.style.left = '9px';
			prevLink.style.zIndex = '70';
			prevLink.src = option.previmg;
			self._prev = prevLink;
			Spica.Event.register(prevLink,'mouseover',function() { self._actionEnabled = true; self._show_action(); });
			Spica.Event.register(prevLink,'click',function() { self._show_next(-1); });
		}
		// create hover navi - next
		if (option.nextimg)
		{
			var nextLink = document.createElement('img');
			box.appendChild(nextLink);
			nextLink.id = 'nextLink';
			nextLink.style.display = 'none';
			nextLink.style.position = 'absolute';
			nextLink.style.right = '9px';
			nextLink.style.zIndex = '70';
			nextLink.src = option.nextimg;
			self._next = nextLink;
			Spica.Event.register(nextLink,'mouseover',function() { self._actionEnabled = true; self._show_action(); });
			Spica.Event.register(nextLink,'click',function() { self._show_next(+1); });
		}
		// create zoom indicator
		var zoom = document.createElement('img');
		box.appendChild(zoom);
		zoom.id = 'actionImage';
		zoom.style.display = 'none';
		zoom.style.position = 'absolute';
		zoom.style.top = '15px';
		zoom.style.left = '15px';
		zoom.style.zIndex = '70';
		self._set_cursor(zoom);
		zoom.src = self._expand;
		Spica.Event.register(zoom,'mouseover',function() { self._actionEnabled = true; self._show_action(); });
		Spica.Event.register(zoom,'click', function() { self._zoom(); });
		// create close button
		if (option.closeimg)
		{
			var btn = document.createElement('img');
			box.appendChild(btn);
			btn.id = 'closeButton';
			btn.style.display = 'inline';
			btn.style.position = 'absolute';
			btn.style.right = '9px';
			btn.style.top = '10px';
			btn.style.zIndex = '80';
			btn.src = option.closeimg;
			self._set_cursor(btn);
			Spica.Event.register(btn,'click',function(evt) { self._close(evt); });
		}
		// caption text
		var caption = document.createElement('span');
		box.appendChild(caption);
		caption.id = 'lightboxCaption';
		caption.style.display = 'none';
		caption.style.position = 'absolute';
		caption.style.zIndex = '80';
		// create effect image
		if (!option.effectpos)
			option.effectpos = {x:0,y:0};
		else
		{
			if (option.effectpos.x == '') option.effectpos.x = 0;
			if (option.effectpos.y == '') option.effectpos.y = 0;
		}
		var effect = new Image;
		effect.onload = function()
		{
			var effectImg = document.createElement('img');
			box.appendChild(effectImg);
			effectImg.id = 'effectImage';
			effectImg.src = effect.src;
			if (option.effectclass) effectImg.className = option.effectclass;
			effectImg.style.position = 'absolute';
			effectImg.style.display = 'none';
			effectImg.style.left = [option.effectpos.x,'px'].join('');;
			effectImg.style.top = [option.effectpos.y,'px'].join('');
			effectImg.style.zIndex = '90';
			self._set_cursor(effectImg);
			Spica.Event.register(effectImg,'click',function() { effectImg.style.display = 'none'; });
		};
		if (option.effectimg != '') effect.src = option.effectimg;
		if (self._resizable)
		{
			var overall = document.createElement('div');
			obj.appendChild(overall);
			overall.id = 'lightboxOverallView';
			overall.style.display = 'none';
			overall.style.position = 'absolute';
			overall.style.zIndex = '70';
			self._overall = overall;
			var indicator = document.createElement('div');
			obj.appendChild(indicator);
			indicator.id = 'lightboxIndicator';
			indicator.style.display = 'none';
			indicator.style.position = 'absolute';
			indicator.style.zIndex = '80';
			self._indicator = indicator;
		}
		return box;
	},
	_set_photo_size : function()
	{
		var self = this;
		if (self._open == -1) return;
		var heightmargin = 30;
		var caption = document.getElementById('lightboxCaption');
		if (caption)
			heightmargin += caption.clientHeight || caption.offsetHeight;
		var targ = { w:self._page.win.w - 30, h:self._page.win.h - heightmargin };
		var zoom = { x:15, y:15 };
		var navi = { p:9, n:9, y:0 };
		if (!self._expanded)
		{ // shrink image with the same aspect
			var orig = { w:self._imgs[self._open].w, h:self._imgs[self._open].h };
			if ( orig.w < 0 ) orig.w = self._img.width;
			if ( orig.h < 0 ) orig.h = self._img.height;
			var ratio = 1.0;
			if ((orig.w >= targ.w || orig.h >= targ.h) && orig.h && orig.w)
				ratio = ((targ.w / orig.w) < (targ.h / orig.h)) ? targ.w / orig.w : targ.h / orig.h;
			self._expandable = (ratio < 1.0) ? true : false;
			self._anim.w = Math.floor(orig.w * ratio);
			self._anim.h = Math.floor(orig.h * ratio);
			if (self._resizable) self._expandable = true;
			if (Spica.Browser.isWinIE) self._box.style.display = "block";
			self._imgpos.x = self._pos.x + (targ.w - self._img.width) / 2;
			self._imgpos.y = self._pos.y + (targ.h - self._img.height) / 2;
			navi.y = Math.floor(self._img.height / 2) - 10;
			self._show_overall(false);
			var loading = document.getElementById('loadingImage');
			if (loading)
			{
				loading.style.left = [(self._img.width - 30) / 2,'px'].join('');
				loading.style.top  = [(self._img.height - 30) / 2,'px'].join('');
			}
			if (caption)
			{
				caption.style.top = [self._img.height + 10,'px'].join(''); // 10 is top margin of lightbox
				caption.style.width = [self._img.width + 20,'px'].join(''); // 20 is total side margin of lightbox
			}
		}
		else
		{ // zoomed or actual sized image
			var width  = parseInt(self._imgs[self._open].w * self._level);
			var height = parseInt(self._imgs[self._open].h * self._level);
			self._minpos.x = self._pos.x + targ.w - self._img.width;
			self._minpos.y = self._pos.y + targ.h - self._img.height;
			if (self._img.width <= targ.w)
				self._imgpos.x = self._pos.x + (targ.w - self._img.width) / 2;
			else
			{
				if (self._imgpos.x > self._pos.x) self._imgpos.x = self._pos.x;
				else if (self._imgpos.x < self._minpos.x) self._imgpos.x = self._minpos.x;
				zoom.x = 15 + self._pos.x - self._imgpos.x;
				navi.p = self._pos.x - self._imgpos.x - 5;
				navi.n = self._img.width - self._page.win.w + self._imgpos.x + 25;
				if (Spica.Browser.isWinIE) navi.n -= 10;
			}
			if (self._img.height <= targ.h)
			{
				self._imgpos.y = self._pos.y + (targ.h - self._img.height) / 2;
				navi.y = Math.floor(self._img.height / 2) - 10;
			}
			else
			{
				if (self._imgpos.y > self._pos.y) self._imgpos.y = self._pos.y;
				else if (self._imgpos.y < self._minpos.y) self._imgpos.y = self._minpos.y;
				zoom.y = 15 + self._pos.y - self._imgpos.y;
				navi.y = Math.floor(targ.h / 2) - 10 + self._pos.y - self._imgpos.y;
			}
			self._anim.w = width;
			self._anim.h = height;
			self._show_overall(true);
		}
		self._box.style.left = [self._imgpos.x,'px'].join('');
		self._box.style.top  = [self._imgpos.y,'px'].join('');
		self._zoomimg.style.left = [zoom.x,'px'].join('');
		self._zoomimg.style.top  = [zoom.y,'px'].join('');
		self._wrap.style.left = self._pos.x;
		if (self._prev && self._next)
		{
			self._prev.style.left  = [navi.p,'px'].join('');
			self._next.style.right = [navi.n,'px'].join('');
			self._prev.style.top = self._next.style.top = [navi.y,'px'].join('');
		}
		self._changed = true;
	},
	_show_overall : function(visible)
	{
		var self = this;
		if (self._overall == null) return;
		if (visible)
		{
			if (self._open == -1) return;
			var base = 100;
			var outer = { w:0, h:0, x:0, y:0 };
			var inner = { w:0, h:0, x:0, y:0 };
			var orig = { w:self._img.width , h:self._img.height };
			var targ = { w:self._page.win.w - 30, h:self._page.win.h - 30 };
			var max = orig.w;
			if (max < orig.h) max = orig.h;
			if (max < targ.w) max = targ.w;
			if (max < targ.h) max = targ.h;
			if (max < 1) return;
			outer.w = parseInt(orig.w / max * base);
			outer.h = parseInt(orig.h / max * base);
			inner.w = parseInt(targ.w / max * base);
			inner.h = parseInt(targ.h / max * base);
			outer.x = self._pos.x + targ.w - base - 20;
			outer.y = self._pos.y + targ.h - base - 20;
			inner.x = outer.x - parseInt((self._imgpos.x - self._pos.x) / max * base);
			inner.y = outer.y - parseInt((self._imgpos.y - self._pos.y) / max * base);
			self._overall.style.left = [outer.x,'px'].join('');
			self._overall.style.top  = [outer.y,'px'].join('');
			self._overall.style.width  = [outer.w,'px'].join('');
			self._overall.style.height = [outer.h,'px'].join('');
			self._indicator.style.left = [inner.x,'px'].join('');
			self._indicator.style.top  = [inner.y,'px'].join('');
			self._indicator.style.width  = [inner.w,'px'].join('');
			self._indicator.style.height = [inner.h,'px'].join('');
			self._overall.style.display = 'block'
			self._indicator.style.display = 'block';
		}
		else
		{
			self._overall.style.display = 'none';
			self._indicator.style.display = 'none';
		}
	},
	_set_size : function(onResize)
	{
		var self = this;
		if (self._open == -1) return;
		if (!self._page.update() && !self._pos.update() && !self._changed) return;
		if (Spica.Browser.isWinIE)
		{
			self._wrap.style.width  = [self._page.win.w,'px'].join('');
			self._wrap.style.height = [self._page.win.h,'px'].join('');
			self._wrap.style.top = [self._pos.y,'px'].join('');
		}
		if (onResize) self._set_photo_size();
	},
	_set_cursor : function(obj)
	{
		var self = this;
		if (Spica.Browser.isWinIE && !Spica.Browser.isNewIE) return;
		obj.style.cursor = 'pointer';
	},
	_current_setindex : function()
	{
		var self = this;
		if (!self._openedset) return -1;
		var list = self._sets[self._openedset];
		for (var i=0,n=list.length;i<n;i++)
		{
			if (list[i] == self._open) return i;
		}
		return -1;
	},
	_get_setlength : function()
	{
		var self = this;
		if (!self._openedset) return -1;
		return self._sets[self._openedset].length;
	},
	_show_action : function()
	{
		var self = this;
		if (self._open == -1) return;
		var check = self._current_setindex();
		if (check > -1)
		{
			if (check > 0) self._prev.style.display = 'inline';
			if (check < self._get_setlength() - 1) self._next.style.display = 'inline';
		}
		if (!self._expandable || !self._zoomimg) return;
		self._zoomimg.src = (self._expanded) ? self._shrink : self._expand;
		self._zoomimg.style.display = 'inline';
	},
	_hide_action : function()
	{
		var self = this;
		if (self._zoomimg) self._zoomimg.style.display = 'none';
		if (self._open > -1 && self._expanded) self._dragstop(null);
		if (self._prev) self._prev.style.display = 'none';
		if (self._next) self._next.style.display = 'none';
	},
	_zoom : function()
	{
		var self = this;
		var closeBtn = document.getElementById('closeButton');
		if (self._expanded)
		{
			self._reset_func();
			self._expanded = false;
			if (closeBtn) closeBtn.style.display = 'inline';
		}
		else if (self._open > -1)
		{
			self._level = 1;
			self._imgpos.x = self._pos.x;
			self._imgpos.y = self._pos.y;
			self._expanded = true;
			self._funcs.drag  = function(evt) { self._dragstart(evt) };
			self._funcs.dbl   = function(evt) { self._close(null) };
			if (self._resizable)
			{
				self._funcs.wheel = function(evt) { self._onwheel(evt) };
				Spica.Event.register(self._box,'mousewheel',self._funcs.wheel);
			}
			Spica.Event.register(self._img,'mousedown',self._funcs.drag);
			Spica.Event.register(self._img,'dblclick',self._funcs.dbl);
			self._show_caption(false);
			if (closeBtn) closeBtn.style.display = 'none';
		}
		self._set_photo_size();
		self._show_action();
	},
	_reset_func : function()
	{
		var self = this;
		if (self._funcs.wheel != null) Spica.Event.deregister(self._box,'mousewheel',self._funcs.wheel);
		if (self._funcs.move  != null) Spica.Event.deregister(self._img,'mousemove',self._funcs.move);
		if (self._funcs.up    != null) Spica.Event.deregister(self._img,'mouseup',self._funcs.up);
		if (self._funcs.drag  != null) Spica.Event.deregister(self._img,'mousedown',self._funcs.drag);
		if (self._funcs.dbl   != null) Spica.Event.deregister(self._img,'dblclick',self._funcs.dbl);
		self._funcs = {'move':null,'up':null,'drag':null,'wheel':null,'dbl':null};
	},
	_onwheel : function(evt)
	{
		var self = this;
		var delta = 0;
		evt = Spica.Event.getEvent(evt);
		if (evt.wheelDelta)  delta = event.wheelDelta/-120;
		else if (evt.detail) delta = evt.detail/3;
		if (Spica.Browser.isOpera) delta = - delta;
		var step =
			  (self._level < 1) ? 0.1
			: (self._level < 2) ? 0.25
			: (self._level < 4) ? 0.5
			: 1;
		self._level = (delta > 0) ? self._level + step : self._level - step;
		if (self._level > 8) self._level = 8;
		else if (self._level < 0.5) self._level = 0.5;
		self._set_photo_size();
		return Spica.Event.stop(evt);
	},
	_dragstart : function(evt)
	{
		var self = this;
		evt = Spica.Event.getEvent(evt);
		self._curpos.x = evt.screenX;
		self._curpos.y = evt.screenY;
		self._funcs.move = function(evnt) { self._dragging(evnt); };
		self._funcs.up   = function(evnt) { self._dragstop(evnt); };
		Spica.Event.register(self._img,'mousemove',self._funcs.move);
		Spica.Event.register(self._img,'mouseup',self._funcs.up);
		return Spica.Event.stop(evt);
	},
	_dragging : function(evt)
	{
		var self = this;
		evt = Spica.Event.getEvent(evt);
		self._imgpos.x += evt.screenX - self._curpos.x;
		self._imgpos.y += evt.screenY - self._curpos.y;
		self._curpos.x = evt.screenX;
		self._curpos.y = evt.screenY;
		self._set_photo_size();
		return Spica.Event.stop(evt);
	},
	_dragstop : function(evt)
	{
		var self = this;
		evt = Spica.Event.getEvent(evt);
		if (self._funcs.move  != null) Spica.Event.deregister(self._img,'mousemove',self._funcs.move);
		if (self._funcs.up    != null) Spica.Event.deregister(self._img,'mouseup',self._funcs.up);
		self._funcs.move = null;
		self._funcs.up   = null;
		self._set_photo_size();
		return (evt) ? Spica.Event.stop(evt) : false;
	},
	_show_caption : function(enable,initializing)
	{
		var self = this;
		var caption = document.getElementById('lightboxCaption');
		if (!caption) return;
		if (caption.innerHTML.length == 0 || !enable)
		{
			caption.style.display = 'none';
		}
		else
		{ // now display caption
			caption.style.top = [self._img.height + 10,'px'].join(''); // 10 is top margin of lightbox
			caption.style.left = '0px';
			caption.style.width = [self._img.width + 20,'px'].join(''); // 20 is total side margin of lightbox
			caption.style.display = 'block';
			self._setOpacity(caption, initializing ? 0 : 9.9);
		}
	},
	_toggle_wrap : function(flag)
	{
		var self = this;
		self._wrap.style.display = flag ? "block" : "none";
		if (self._hiding.length == 0 && !self._first)
		{ // some objects may overlap on overlay, so we hide them temporarily.
			var tags = ['select','embed','object'];
			for (var i=0,n=tags.length;i<n;i++)
			{
				var elem = document.getElementsByTagName(tags[i]);
				for (var j=0,m=elem.length;j<m;j++)
				{ // check the original value at first. when already hidden, dont touch them
					var check = elem[j].style.visibility;
					if (!check)
					{
						if (elem[j].currentStyle)
							check = elem[j].currentStyle['visibility'];
						else if (document.defaultView)
							check = document.defaultView.getComputedStyle(elem[j],'').getPropertyValue('visibility');
					}
					if (check == 'hidden') continue;
					self._hiding.push(elem[j]);
				}
			}
			self._first = true;
		}
		for (var i=0,n=self._hiding.length;i<n;i++)
			self._hiding[i].style.visibility = flag ? "hidden" : "visible";
		if ( flag )
			self._setOpacity(self._wrap,5);
	},
	_prepare : function(num)
	{
		var self = this;
		if (self._open == -1) return;
		self._set_size(false); // calc and set wrapper size
		self._toggle_wrap(true);
		self._box.style.display = "block";
		self._hide_action();
		self._img.src = self._blank;
		var loading = document.getElementById('loadingImage');
		if (loading) loading.style.display = 'inline';
		var objs = ['effectImage','closeButton','lightboxCaption'];
		for (var i in objs)
		{
			var obj = document.getElementById(objs[i]);
			if (obj) obj.style.display = 'none';
		}
	},
	_show : function(num)
	{
		var self = this;
		var imag = new Image;
		if (num < 0 || num >= self._imgs.length) return;
		self._open = num; // set opened image number
		self._prepare();
		self._set_photo_size();
		imag.onload = function() {
			self._expanded = false;
			if (self._imgs[self._open].w == -1)
			{ // store original image width and height
				self._imgs[self._open].w = imag.width;
				self._imgs[self._open].h = imag.height;
			}
			var caption = document.getElementById('lightboxCaption');
			if (caption)
			{
				try { caption.innerHTML = self._imgs[self._open].title; } catch(e) {}
				self._show_caption(true,true);
			}
			self._anim.t = (new Date()).getTime();
			self._timer = window.setInterval( function() { self._run() }, 20);
			self._img.setAttribute('title',self._imgs[self._open].title);
			self._anim.step = ( self._anim.f ) ? 0 : 2;
			self._set_photo_size(); // calc and set lightbox size
			if ( !self._anim.f ) // animator is disabled, so apply immediately
				self._show_image();
			if (self._imgs[self._open].set != 'lightbox')
			{
				var set = self._imgs[self._open].set;
				if (self._sets[set].length > 1) self._openedset = set;
				if (!self._prev || !self._next) self._openedset = null;
			}
		};
		self._expandable = false;
		self._expanded = false;
		self._anim.step = -1;
		imag.src = self._imgs[self._open].src;
	},
	_run : function()
	{
		var self = this;
		var t = (new Date()).getTime();
		if ( t - self._anim.t < 50 ) return;
		self._anim.t = t;
		self._set_size(true);
		if ( self._anim.step == 0 || self._anim.w != self._img.width || self._anim.h != self._img.height )
		{
			self._doResizing();
		}
		else if ( self._anim.step == 1 )
		{
			self._doFadeIn();
		}
		else if ( self._anim.step == 3 )
		{
			self._doFadeOut();
		}
	},
	_show_image : function()
	{
		var self = this;
		if (self._open == -1) return;
		self._img.src = self._imgs[self._open].src;
		var loading = document.getElementById('loadingImage');
		if (loading) loading.style.display = 'none';
		var effect = document.getElementById('effectImage');
		if (effect && (!effect.className || self._imgs[self._open].cls == effect.className))
			effect.style.display = 'block';
		var closeBtn = document.getElementById('closeButton');
		if (closeBtn) closeBtn.style.display = 'inline';
		self._show_caption(true);
		if (self._actionEnabled) self._show_action();
	},
	_doResizing : function()
	{
		var self = this;
		var diff = {
			x: ( self._anim.f ) ? Math.floor((self._anim.w - self._img.width) / 3) : 0,
			y: ( self._anim.f ) ? Math.floor((self._anim.h - self._img.height) / 3) : 0
		};
		self._img.width += diff.x;
		self._img.height += diff.y;
		if ( Math.abs(diff.x) < 1 ) self._img.width = self._anim.w;
		if ( Math.abs(diff.y) < 1 ) self._img.height = self._anim.h;
		if ( self._anim.w == self._img.width && self._anim.h == self._img.height )
		{
			self._changed = false;
			self._set_photo_size();
			if ( self._anim.step == 0 )
			{
				self._anim.step = 1; // move on the next stage
				self._anim.a = 0;
				self._show_image();
				self._setOpacity(self._img,self._anim.a);
			}
		}
		else if (self._anim.step == 2 && !self._expanded)
			self._show_caption(true);
	},
	_doFadeIn : function()
	{
		var self = this;
		self._anim.a += 2;
		if ( self._anim.a > 10 )
		{
			self._anim.step = 2; // move on the next stage
			self._anim.a = 9.9;
		}
		self._setOpacity(self._img,self._anim.a);
	},
	_doFadeOut : function()
	{
		var self = this;
		self._anim.a -= 1;
		if ( self._anim.a < 1 )
		{
			self._anim.step = 2; // finish
			self._anim.a = 0;
			if ( self._timer != null )
			{
				window.clearInterval(self._timer);
				self._timer = null;
			}
			self._toggle_wrap(false);
		}
		self._setOpacity(self._wrap,self._anim.a);
	},
	_setOpacity : function(elem, alpha)
	{
		if (Spica.Browser.isWinIE)
			elem.style.filter = 'alpha(opacity=' + (alpha * 10) + ')';
		else
			elem.style.opacity = alpha / 10;
	},
	_close_box : function()
	{
		var self = this;
		self._open = -1;
		self._openedset = null;
		self._hide_action();
		self._reset_func();
		self._show_overall(false);
		self._box.style.display  = "none";
		if ( !self._anim.f && self._timer != null )
		{
			window.clearInterval(self._timer);
			self._timer = null;
		}
	},
	_show_next : function(direction)
	{
		var self = this;
		if (!self._openedset) return self._close(null);
		var index = self._current_setindex() + direction;
		var targ = self._sets[self._openedset][index];
		self._close_box();
		self._show(targ);
	},
	_close : function(evt)
	{
		var self = this;
		if (evt != null)
		{
			evt = Spica.Event.getEvent(evt);
			var targ = evt.target || evt.srcElement;
			if (targ && targ.getAttribute('id') == 'lightboxImage' && self._expanded) return;
		}
		self._close_box();
		if ( self._anim.f && self._anim.step == 2 )
		{
			self._anim.step = 3;
			self._anim.a = 5;
		}
		else
		{
			self._toggle_wrap(false);
		}
	}
};
Spica.Event.run(function() { 
	var lightbox = new Lightbox({
		loadingimg:'lightbox/loading.gif',
		expandimg:'lightbox/expand.gif',
		shrinkimg:'lightbox/shrink.gif',
		blankimg:'lightbox/blank.gif',
		previmg:'lightbox/prev.gif',
		nextimg:'lightbox/next.gif',
		closeimg:'lightbox/close.gif',
		effectimg:'lightbox/zzoop.gif',
		effectpos:{x:-40,y:-20},
		effectclass:'effectable',
		resizable:true,
		animation:true
	});
});
