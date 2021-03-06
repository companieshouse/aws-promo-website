
$.gloss = function (options){
    // Default settings.
    var settings = {
	/* Setting the class or ID of element(s) as a selector for jquery
	Use class when you have more than 1 element
	*/
	selector: '.gloss',
            image: 'images/indexPromos/gloss.png', /* PNG file location */
	speed: 1000 /* animation in milliseconds */
    };
    // Exteding options
    settings = $.extend(settings, options);
    
    /**
     * IE 6 transparency PNG fix
     */
    function _ie6fix(){
        // fixing the PNG transparency
        if($.browser.msie && $.browser.version=="6.0"){
            $(".glosser").css({'background':'none','filter':'progid:DXImageTransform.Microsoft.AlphaImageLoader(src=\''+settings.image+'\',sizingMethod=\'scale\')'});
        }
    }
    /**
     * This function applies CSS for container and inside elements.
     */
    function _css(){
        // Preparing CSS for selector elements
        $(settings.selector).css({'position':'relative','overflow':'hidden'})
            /* creating DIV element to make the gloss animation */
            .append('<div class="glosser"></div>').find("img").css({'position':'absolute','top':0,'left':0, 'z-index':5});
        // preparing CSS for gloss div
        $(".glosser").css({'position':'absolute','left':'-450px','top':0,'z-index':10,'width':'450px','height':'500px','background':'url('+settings.image+') 0 0 repeat'});
        _ie6fix();
    }
    
    /**
     * Add hover, onClick actions on the element to make it gloss.
     */
    function _addActions(){
	$(settings.selector).hover(
                /* */
                function (){ glsr = $(this).find(".glosser"); $(glsr).stop().animate({'left':(parseInt($(settings.selector).width())+450) +"px"},settings.speed);},
                function (){glsr = $(this).find(".glosser"); $(glsr).stop().animate({'left':"-450px"},settings.speed);}
            );
    }
    
    /**
     * The initializer for this plugin.
     */
    function _init(){
        _css();
        _addActions();
    }
    
    return _init();
    
};