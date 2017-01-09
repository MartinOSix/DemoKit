//补丁版本 1.1.1
require("UIColor,UILabel,UIButton,ViewController1");

defineClass("ViewController", {
            
            
    btnclick: function() {
        self.ORIGbtnclick();
        var slf = self;
        var test = "执行";
        console.log(test);
        dispatch_after(2, function() {
            slf.view().setBackgroundColor(UIColor.yellowColor());
            var vc = ViewController1.alloc().init();
            slf.presentViewController_animated_completion(vc, YES, null);
            });
        }
}, {});

defineClass("ViewController1:UIViewController", ["label"],{
            
    viewDidLoad: function() {
    self.super().viewDidLoad();
    self.view().setBackgroundColor(UIColor.blueColor());
    var btn = UIButton.buttonWithType(0);
    btn.setFrame({x:20, y:20, width:100, height:100});
    btn.setBackgroundColor(UIColor.yellowColor());
    btn.addTarget_action_forControlEvents(self, "btnclick1", 1<<6);
    self.view().addSubview(btn);
            
            
    var label = UILabel.alloc().init();
    label.setFrame({x:20, y:120, width:100, height:100});
    label.setBackgroundColor(UIColor.whiteColor());
    self.view().addSubview(label);
    console.log(label);
    self.setLabel(label);
    console.log(self.label());
    },

    btnclick1: function() {
        
        var label = self.label();
        console.log(label);
        label.setBackgroundColor(UIColor.redColor());
        label.setText("hahaha");
        var slf = self;
        dispatch_after(2, function() {
            slf.dismissViewControllerAnimated_completion(YES, null);
        });
    }
            
            
            
}, {});
