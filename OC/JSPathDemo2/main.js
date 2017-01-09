//补丁版本 1.1.1
require("UIColor,UIButton,ViewController1");

defineClass("ViewController", {
    btnclick: function() {
        self.ORIGbtnclick();
        var slf = self;
        dispatch_after(5, function() {
            slf.view().setBackgroundColor(UIColor.yellowColor());
            var vc = ViewController1.alloc().init();
            slf.presentViewController_animated_completion(vc, YES, null);
        });
    }
}, {});

defineClass("ViewController1:UIViewController", {

	viewDidLoad: function() {
		self.super().viewDidLoad();
		self.view().setBackgroundColor(UIColor.redColor());
		var btn = UIButton.buttonWithType(UIButtonTypeCustom);
		btn.setFrame(CGRectMake(100, 100, 100, 100));
		btn.setBackgroundColor(UIColor.blueColor());
		btn.addTarget_action_forControlEvents(self, "btnclick", UIControlEventTouchUpInside);
		self.view().addSubview(btn);
	}
	btnclick: function() {
		self.dismissViewControllerAnimated_completion(YES, null);
    }
}, {});
