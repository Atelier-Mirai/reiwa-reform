(() => {
  var e = {
      805: e => {
        "use strict";
        e.exports = i, e.exports.isMobile = i, e.exports.default = i;
        var t = /(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series[46]0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i,
          n = /(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series[46]0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino|android|ipad|playbook|silk/i;

        function i(e) {
          e || (e = {});
          var i = e.ua;
          if (i || "undefined" == typeof navigator || (i = navigator.userAgent), i && i.headers && "string" == typeof i.headers["user-agent"] && (i = i.headers["user-agent"]), "string" != typeof i) return !1;
          var o = e.tablet ? n.test(i) : t.test(i);
          return !o && e.tablet && e.featureDetect && navigator && navigator.maxTouchPoints > 1 && -1 !== i.indexOf("Macintosh") && -1 !== i.indexOf("Safari") && (o = !0), o
        }
      }
    },
    t = {};

  function n(i) {
    if (t[i]) return t[i].exports;
    var o = t[i] = {
      exports: {}
    };
    return e[i](o, o.exports, n), o.exports
  }! function (e) {
    if (void 0 === e.ltg) {
      var t = function (e, t) {
        Array.prototype.forEach.call(document.querySelectorAll(e), t)
      };
      e.ltg = {}, e.ltg.action = t, e.ltg.removeClass = function (e, n) {
        t(e, (function (e) {
          return e.classList.remove(n)
        }))
      }, e.ltg.addClass = function (e, n) {
        t(e, (function (e) {
          return e.classList.add(n)
        }))
      }, e.ltg.swap = function (e, n, i) {
        t(e, (function (e) {
          e.classList.remove(n), e.classList.add(i)
        }))
      }
    }
  }(window),
  function (e, t) {
    var n = e.ltg.addClass,
      i = (e.ltg.swap, function () {
        e.pageYOffset > 0 ? t.body.classList.add("scrolled") : t.body.classList.remove("scrolled")
      });
    if (e.addEventListener("scroll", i, !1), e.addEventListener("DOMContentLoaded", i, !1), lightningOpt.header_scrool) {
      var o = !1,
        a = !1,
        s = function () {
          !a && e.pageYOffset > 160 ? t.body.classList.add("header_scrolled") : t.body.classList.remove("header_scrolled")
        },
        r = function (n) {
          t.body.classList.remove("header_scrolled"), e.removeEventListener("scroll", s), !1 !== o && clearTimeout(o), a = !0, o = setTimeout((function () {
            e.addEventListener("scroll", s, !0), a = !1
          }), 2e3)
        };
      e.addEventListener("DOMContentLoaded", (function () {
        Array.prototype.forEach.call(t.getElementsByTagName("a"), (function (e) {
          var t = e.getAttribute("href");
          t && 0 == t.indexOf("#") && (["tab", "button"].indexOf(e.getAttribute("role")) > 0 || e.getAttribute("data-toggle") || e.getAttribute("carousel-control") || e.addEventListener("click", r))
        }))
      })), e.addEventListener("scroll", s, !0), e.addEventListener("DOMContentLoaded", s, !1)
    }

    function l() {
      Array.prototype.forEach.call(t.getElementsByTagName("iframe"), (function (e) {
        var t = e.getAttribute("src");
        if (t && (t.indexOf("youtube") >= 0 || t.indexOf("vimeo") >= 0 || t.indexOf("maps") >= 0)) {
          var n = e.getAttribute("width"),
            i = e.getAttribute("height") / n,
            o = e.offsetWidth * i;
          e.style.maxWidth = "100%", e.style.height = o + "px"
        }
      }))
    }
    e.addEventListener("DOMContentLoaded", (function () {
      n("#top__fullcarousel .carousel-indicators li:first-child", "active"), n("#top__fullcarousel .item:first-child", "active")
    })), e.addEventListener("DOMContentLoaded", l);
    var c = !1;
    e.addEventListener("resize", (function () {
      c && clearTimeout(c), c = setTimeout(l, 200)
    })), e.addEventListener("DOMContentLoaded", (function () {
      n("textarea", "form-control"), n("select", "form-control"), n("input[type=text]", "form-control"), n("input[type=number]", "form-control"), n("input[type=search]", "form-control"), n("input[type=password]", "form-control"), n("input[type=email]", "form-control"), n("input[type=tel]", "form-control"), n("input[type=submit]", "btn"), n("input[type=submit]", "btn-primary"), n("form#searchform", "form-inline"), n("form#searchform input[type=text]", "form-group")
    }), !1)
  }(window, document),
  function (e, t, n) {
    var i = !1;

    function o() {
      if (!t.body.classList.contains("jpnstyle")) {
        var e = t.getElementsByClassName("siteHeader")[0];
        e.style.position = "fixed";
        var n = e.clientHeight;
        if (e.nextElementSibling.style.marginTop = n + "px", t.body.classList.contains("admin-bar")) {
          var i = t.getElementById("wpadminbar").clientHeight;
          e.style.top = i + "px"
        }
      }
    }
    e.addEventListener("DOMContentLoaded", (function () {
      t.body.classList.contains("headfix") && (e.addEventListener("resize", (function () {
        !1 !== i && clearTimeout(i), i = setTimeout(o, 300)
      })), o())
    })), e.addEventListener("DOMContentLoaded", (function () {
      if (t.body.classList.contains("header_height_changer")) {
        var i = t.querySelector(".navbar-brand img").clientHeight,
          a = t.body.clientWidth;
        i < 38 && (i = a >= 991 ? 60 : 40), e.addEventListener("scroll", (function () {
          t.body.clientWidth >= 991 && ((e.pageYOffset || t.documentElement.scrollTop) > 10 ? function (e) {
            var t = .8 * e;
            n(".siteHeader .siteHeadContainer").stop().animate({
              "padding-top": "5px",
              "padding-bottom": "0px"
            }, 100), n(".navbar-brand img").stop().animate({
              "max-height": t + "px"
            }, 100)
          }(i) : function (e) {
            n(".siteHeader .siteHeadContainer").stop().animate({
              "padding-top": "20px",
              "padding-bottom": "18px"
            }, 100, (function () {
              o()
            })), n(".navbar-brand img").stop().animate({
              "max-height": e + "px"
            }, 100)
          }(i))
        }))
      }
    }))
  }(window, document, jQuery),
  function (e, t) {
    function n() {
      var e = t.getElementsByClassName("sideSection")[0];
      e.style.position = null, e.style.top = null, e.style.bottom = null, e.style.left = null, e.style.right = null, e.style.width = null
    }

    function i() {
      var e = t.getElementById("gMenu_outer");
      return (e ? e.getBoundingClientRect().bottom : 0) + 40
    }

    function o() {
      var o = "top";
      1 == t.body.classList.contains("sidebar-fix-priority-top") ? o = "top" : 1 == t.body.classList.contains("sidebar-fix-priority-bottom") && (o = "bottom");
      var a = t.body.offsetWidth,
        s = t.documentElement.clientHeight;
      if (a < 992) n();
      else {
        var r = t.getElementsByClassName("mainSection")[0],
          l = t.getElementsByClassName("sideSection")[0],
          c = l.parentNode,
          d = r.getBoundingClientRect().top + e.pageYOffset,
          u = r.offsetHeight,
          f = l.offsetHeight,
          p = l.offsetWidth,
          m = d + f;
        l.style.position = null, l.style.left = null;
        var v = l.getBoundingClientRect().left + e.pageXOffset,
          b = s - i();
        "bottom" === o && b > f && (o = "top");
        var g = d + u - s,
          y = u - f,
          h = m - s,
          L = d - i();
        if (f > u) return;
        var x = !1;
        L < e.pageYOffset && (x = !0);
        var E = !1;
        i() + f > r.getBoundingClientRect().bottom && (E = !0);
        var k = !1;
        h < e.pageYOffset && (k = !0);
        var w = !1;
        g < e.pageYOffset && (w = !0), "top" === o ? x ? (l.style.position = "fixed", l.style.top = i() + "px", l.style.left = v + "px", l.style.width = p + "px", E && (l.style.position = null, l.style.left = null, l.style.width = null, l.style.top = y + "px")) : n() : k ? (l.style.position = "fixed", l.style.bottom = "30px", l.style.left = v + "px", l.style.width = p + "px", w && (l.style.left = null, c.style.position = "relative", l.style.position = "absolute", l.style.bottom = 0, 1 != l.classList.contains("sideSection-pos-left") && (l.style.right = 0))) : n()
      }
    }
    e.addEventListener("scroll", (function () {
      t.body.classList.contains("sidebar-fix") && (t.getElementsByClassName("sideSection").length < 1 || o())
    })), e.addEventListener("resize", (function () {
      t.body.classList.contains("sidebar-fix") && (t.getElementsByClassName("sideSection").length < 1 || o())
    }))
  }(window, document),
  function (e, t) {
    e.addEventListener("load", (function () {
      (i = t.getElementsByClassName("vk-prlx")).length < 1 || (Array.prototype.forEach.call(i, (function (e) {
        var t = e.style.backgroundImage.replace(n, "$1");
        if ("none" != t) {
          var i = new Image;
          i.src = t, e.setAttribute("image_rate", i.width / i.height), e.setAttribute("image_w", i.width), e.setAttribute("image_h", i.height)
        }
      })), e.addEventListener("scroll", o), e.addEventListener("resize", o))
    }));
    var n = /.*url\(['"]*(.*?)['"]*\).*/g,
      i = [];

    function o() {
      var o = e.pageYOffset || t.documentElement.scrollTop,
        a = t.documentElement.clientHeight;
      Array.prototype.forEach.call(i, (function (e) {
        e.style.backgroundImage.replace(n, "$1");
        var t = e.getAttribute("image_rate");
        if (t) {
          e.getAttribute("image_w");
          var i, s = e.getAttribute("image_h"),
            r = e.offsetWidth,
            l = e.offsetHeight,
            c = 0,
            d = 0;
          (i = l + 1 * l) < s ? (d = s, c = s * t) : (d = i, c = i * t), c < r && (c = r, d = r / t);
          var u = e.getBoundingClientRect().top + o - a,
            f = 0;
          if (u < o) {
            var p = (i - l) / (a + l) * (o - u);
            i < d && (f = (d - i) / 2), p = -(i - l) + p;
            var m = "center " + (p -= f) + "px";
            e.style.backgroundPosition = m
          }
          e.style.backgroundSize = c + "px " + d + "px"
        }
      }))
    }
  }(window, document), (() => {
    ! function (e, t) {
      function n(e, n) {
        Array.prototype.forEach.call(t.querySelectorAll(e), n)
      }

      function i(e, t) {
        n(e, (function (e) {
          return e.classList.remove(t)
        }))
      }

      function o(e, t) {
        n(e, (function (e) {
          return e.classList.add(t)
        }))
      }! function (e, t, i) {
        function a(e) {
          t.getElementById("vk-mobile-nav-menu-btn").classList.remove("menu-open"), t.getElementById("vk-mobile-nav").classList.remove("vk-mobile-nav-open")
        }
        e.addEventListener("DOMContentLoaded", (function () {
          var e;
          (e = t.getElementById("vk-mobile-nav-menu-btn")).addEventListener("click", (function () {
            e.classList.contains("menu-open") ? a() : (o(".vk-mobile-nav-menu-btn", "menu-open"), t.getElementById("vk-mobile-nav").classList.add("vk-mobile-nav-open"))
          })), n(".vk-mobile-nav li > a", (function (e) {
            e.addEventListener("click", (function (e) {
              e.target.getAttribute("href").indexOf(!1) && a()
            }))
          }))
        }))
      }(e, t),
      function (a) {
        function s() {
          e.innerWidth <= 5e3 ? (r(), o("ul.vk-menu-acc", "vk-menu-acc-active"), n("ul.vk-menu-acc ul.sub-menu", (function (e) {
            var n = t.createElement("span");
            n.classList.add("acc-btn", "acc-btn-open"), n.addEventListener("click", l), e.parentNode.insertBefore(n, e), e.classList.add("acc-child-close")
          }))) : r()
        }

        function r() {
          i("ul.vk-menu-acc", "vk-menu-acc-active"), i("ul.vk-menu-acc li", "acc-parent-open"), n("ul.vk-menu-acc li .acc-btn", (function (e) {
            return e.remove()
          })), i("ul.vk-menu-acc li .acc-child-close", "acc-child-close"), i("ul.vk-menu-acc li .acc-child-open", "acc-child-open")
        }

        function l(e) {
          var t = e.target,
            n = t.parentNode,
            i = t.nextSibling;
          t.classList.contains("acc-btn-open") ? (n.classList.add("acc-parent-open"), t.classList.remove("acc-btn-open"), t.classList.add("acc-btn-close"), i.classList.remove("acc-child-close"), i.classList.add("acc-child-open")) : (n.classList.remove("acc-parent-open"), t.classList.remove("acc-btn-close"), t.classList.add("acc-btn-open"), i.classList.remove("acc-child-open"), i.classList.add("acc-child-close"))
        }! function () {
          var n = !1,
            i = t.body.offsetWidth,
            o = function () {
              var e = t.body.offsetWidth;
              (e < i - 8 || i + 8 < e) && (s(), i = e)
            };
          e.addEventListener("resize", (function () {
            !1 !== n && clearTimeout(n), n = setTimeout(o, 500)
          }))
        }(), t.addEventListener("DOMContentLoaded", s)
      }()
    }(window, document);
    var e = n(805);
    ! function (t) {
      window.addEventListener("DOMContentLoaded", (function () {
        var n = e.isMobile({
          tablet: !0
        });
        ["device-mobile", "device-pc"].forEach((function (e) {
          return t.body.classList.remove(e)
        })), t.body.classList.add(n ? "device-mobile" : "device-pc")
      }))
    }(document)
  })()
})();
