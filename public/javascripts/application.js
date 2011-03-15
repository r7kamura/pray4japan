// buttonSelectorクリック時にbuttonSelectorを消してloadingImgSelectorを表示
var addLoadingImage = function(buttonSelector, loadingImgSelector) {
  $(buttonSelector).click(function(){
    $(loadingImgSelector).slideDown();
    $(this).slideUp();
  });
};

// 0から(max - 1)までのランダムな自然数を生成
var selectRandElem = function(array) {
  return array[parseInt(Math.random() * array.length)];
};

var createMap = function(opt) {
  var settings = {
    mapSelector:        "#mapBox",// 地図を入れる要素のセレクタ
    zoom:               2,        // 地図の縮尺比率
    interval:           7 * 1000, // 吹出し表示切替間隔[sec]
    centerLat:          35.684,   // 地図中心緯度
    centerLng:          139.774,  // 地図中心軽度
    iconSize:           25,       // マーカーのサイズ[px]
    iconShadowSize:     0,        // マーカーの影のサイズ[px]
    controllerEnabled:  true,     // 地図のコントローラを表示
    smoothZoomEnabled:  true      // 滑らかなズームを有効化
  };
  $.extend(settings, opt);

	// IPアドレスからアクセス元の現在地座標を取得
	var centerLat = (google.loader && google.loader.ClientLocation.latitude)  || settings.centerLat;
	var centerLng = (google.loader && google.loader.ClientLocation.longitude) || settings.centerLng;

  var map = new GMap2($(settings.mapSelector).get(0));
	map.setCenter(new GLatLng(centerLat, centerLng), settings.zoom);
  if (settings.controllerEnabled) { map.addControl(new GLargeMapControl); }
  if (settings.smoothZoomEnabled && !map.continuousZoomEnabled()) { map.enableContinuousZoom(); }
  map.settings = settings;
  return map;
};

// mapにitemのアイコンを配置. itemには[user_picture_url,lat,lng]が必要
var plotIcon = function(map, item){
  var icon = new GIcon(G_DEFAULT_ICON);
  $.extend(icon, {
    iconSize:   new GSize(map.settings.iconSize, map.settings.iconSize),
    shadowSize: new GSize(map.settings.iconShadowSize, map.settings.iconShadowSize),
    image:      item.user_picture_url
  });
  var gLatlng = new GLatLng(item.lat, item.lng);
  var marker = new GMarker(gLatlng, icon);
  map.addOverlay(marker);
  GEvent.addListener(marker, 'click', function(event) {
    map.openInfoWindowHtml(gLatlng, createPopupHtml(item));
    $('a.popup').lightBox();
  });
};

// mapにitemsのアイコンをまとめて配置
var plotIcons = function(map, items){
  var self = this;
  $.each(items, function(i, item){
    self.plotIcon(map, item);
  });  
};

// 吹出し用のHTML生成
var createPopupHtml = function(item) {
  return '\
    <a href="'+item.image_url+'" class="popup" title="<a href=\''+item.link+'\' target=\'_blank\'>'+(item.caption || "")+'</a>" target="_blank">\
      <img src="'+item.image_url+'" width="200" height="200" />\
    </a>';
  return htmlTemplate;
};

// 実行すると地図上の吹出しを更新するようなfunction名を返す
var popup = function(map, items) {
  return function(){
    var randitem = selectRandElem(items);
    map.openInfoWindowHtml(
      new GLatLng(randitem.lat, randitem.lng),
      createPopupHtml(randitem));
    $('a.popup').lightBox();
  };
};


// selectorの位置までscroll
var bindSmoothScroll = function(selector) {
  $(selector).click(function(){
    $('html,body').animate({ scrollTop: $($(this).attr("href")).offset().top }, 'slow','swing');
    return false;
  })
};

// Rails3でAjaxUpdate
var bindRemote = function(selector) {
  $(selector)
    .click(function(){
      $(this).hide();
      $('<img src="/images/loading.gif" class="loading"/>').insertAfter($(this));
    });
  $(selector)
    .bind("ajax:success", function(evt, data, status, xhr){
      $(this)
        .replaceWith(data)
        .fadeIn();
      bindRemote(selector);
      $(".loading").fadeOut();
    });
  $('.images a').lightBox();
};

// twitterのBlogParts
var setTwitterGadget = function() {
  new TWTR.Widget({
    version: 2,
    type: 'search',
    search: 'prayforjapan',
    interval: 2000,
    title: 'Twitter',
    subject: 'prayforjapan',
    width: 'auto',
    height: '600',
    theme: {
      shell: {
        background: 'url("/images/background.png")',
        color: '#444444'
      },
      tweets: {
        background: 'url("/images/background.png")',
        color: '#444444',
        links: '#1985b5'
      }
    },
    features: {
      scrollbar: false,
      loop: true,
      live: true,
      hashtags: true,
      timestamp: true,
      avatars: true,
      toptweets: true,
      behavior: 'default'
    }
  }).render().start();
};

var googleAnalytics = function() {
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-22042269-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
};

$(function(){
  $('.socialButtons .hatena').socialbutton('hatena');
  $('.socialButtons .twitter').socialbutton('twitter', { button: 'horizontal', lang: 'en' });
  $('.socialButtons .facebook').socialbutton('facebook_like', { button: 'button_count', locale: 'en_US' });
  $('.images a').lightBox();
  bindRemote('.moreButton');
  bindSmoothScroll('#navi a');
  startMap();
});
