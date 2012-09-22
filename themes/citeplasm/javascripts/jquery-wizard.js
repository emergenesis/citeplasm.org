// Generated by CoffeeScript 1.3.3
/*
 Wizard Plugin for jQuery
 (c) 2012 Emergenesis
 Licensed Under the Terms of the GNU GPL v3 or later
*/

var $, get_pane, log, wizard, wizardDefaultSettings;

$ = jQuery;

wizardDefaultSettings = {};

log = function(msg) {
  return console.log("[wizard] " + msg);
};

get_pane = function(id, panes) {
  if (id in panes) {
    return panes[id];
  }
  return null;
};

wizard = {
  init: function(options) {
    var wizardSettings;
    wizardSettings = $.extend({}, wizardDefaultSettings, options);
    return this.each(function() {
      var $active_pane, $panes, $this;
      $this = $(this);
      log("Initiating Wizard on " + this);
      $this.data('wizardSettings', wizardSettings);
      $panes = $('.wizard-pane', $this);
      $active_pane = $panes.filter('.active');
      $panes.each(function() {
        var $pane, pane, pane_id;
        $pane = $(this);
        pane_id = $pane.attr('id');
        pane = get_pane(pane_id, wizardSettings.panes);
        if (pane != null) {
          log("Pane " + $pane + " has a definition");
          return pane.node = $pane;
        } else {
          return log("Pane " + $pane + " does not have a definition");
        }
      });
      if ($active_pane.length !== 1) {
        log("There were no active panes. Activating first pane.");
        $active_pane = $panes.filter(':first');
        return $this.wizard('show', $active_pane.attr('id'));
      }
    });
  },
  next: function() {
    return this.each(function() {
      var $active, $next, $panes, $this;
      log('Advancing to the next pane.');
      $this = $(this);
      $panes = $('.wizard-pane', $this);
      $active = $('.active', $this);
      if (!($active != null)) {
        $.error('Wizard was not initiated!');
        return;
      }
      $next = $active.next('.wizard-pane');
      if ($next.length !== 1) {
        log('There is no next pane.');
        return;
      }
      return $this.wizard('show', $next.attr('id'));
    });
  },
  prev: function() {
    return this.each(function() {
      var $active, $panes, $prev, $this, pane, settings;
      log('Going back to the previous pane.');
      $this = $(this);
      $panes = $('.wizard-pane', $this);
      settings = $this.data('wizardSettings');
      $active = $('.active', $this);
      if (!($active != null)) {
        $.error('Wizard was not initiated!');
        return;
      }
      $prev = $active.prev('.wizard-pane');
      if ($prev.length !== 1) {
        log('There is no previous pane.');
        return;
      }
      pane = get_pane($active.attr('id'), settings.panes);
      if (pane != null) {
        pane.undo();
      }
      return $this.wizard('show', $prev.attr('id'));
    });
  },
  show: function(id) {
    return this.each(function() {
      var $active_pane, $panes, $target_pane, $this, next, settings, transition;
      $this = $(this);
      $panes = $('.wizard-pane', $this);
      settings = $this.data('wizardSettings');
      $active_pane = $panes.filter('.active');
      $target_pane = $("#" + id);
      transition = $active_pane && $.support.transition && $active_pane.hasClass('fade');
      next = function() {
        var pane;
        $active_pane.removeClass('active');
        $target_pane.addClass('active');
        if (transition) {
          $target_pane.addClass('in');
        }
        pane = get_pane(id, settings.panes);
        if (pane != null) {
          pane["do"]();
        }
        if ($target_pane.next('.wizard-pane').length !== 1) {
          $('[data-wizard-action="next"]').addClass('disabled');
        } else {
          $('[data-wizard-action="next"]').removeClass('disabled');
        }
        if ($target_pane.prev('.wizard-pane').length !== 1) {
          return $('[data-wizard-action="prev"]').addClass('disabled');
        } else {
          return $('[data-wizard-action="prev"]').removeClass('disabled');
        }
      };
      if (transition) {
        $active_pane.one($.support.transition.end, next);
      } else {
        next();
      }
      return $active_pane.removeClass('in');
    });
  }
};

$.fn.wizard = function(method) {
  if (method in wizard) {
    return wizard[method].apply(this, Array.prototype.slice.call(arguments, 1));
  } else if (!(method != null) || typeof method === 'object') {
    return wizard.init.apply(this, arguments);
  } else {
    return $.error("Method " + method + " is undefined on jQuery.wizard.");
  }
};

$(function() {
  $('body').on('click.wizard.data-api', '[data-wizard-action="next"]', function(e) {
    var $this, target;
    e.preventDefault();
    $this = $(this);
    if ($this.hasClass('disabled')) {
      return log('Button is disabled.');
    } else {
      target = $($this.data('target'));
      return target.wizard('next');
    }
  });
  return $('body').on('click.wizard.data-api', '[data-wizard-action="prev"]', function(e) {
    var $this, target;
    e.preventDefault();
    $this = $(this);
    if ($this.hasClass('disabled')) {
      return log('Button is disabled.');
    } else {
      target = $($this.data('target'));
      return target.wizard('prev');
    }
  });
});
