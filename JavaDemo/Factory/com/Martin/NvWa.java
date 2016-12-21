
package com.Martin;

import com.Martin.WhiteHuman;

public class NvWa{

	public static void main(String[] args) {
		
		Human whiteHuman = HumanFactory.createHuman(WhiteHuman.class);
		whiteHuman.cry();
		whiteHuman.laugh();
		whiteHuman.talk();
        
        System.out.println("\n\n黑人");
        Human blackHuman = HumanFactory.createHuman(BlackHuman.class);
        blackHuman.cry();
        blackHuman.laugh();
        blackHuman.talk();

        System.out.println("\n\n黄种人");
        Human yellowHuman = HumanFactory.createHuman(YellowHuman.class);
        yellowHuman.cry();
        yellowHuman.laugh();
        yellowHuman.talk();

        for (int i = 0; i<10; i++) {
        	System.out.println("\n\n\n---随机产生人种------");
        	Human human = HumanFactory.createHuman();
        	human.cry();
        	human.laugh();
        	human.talk();
        }


	}

}
