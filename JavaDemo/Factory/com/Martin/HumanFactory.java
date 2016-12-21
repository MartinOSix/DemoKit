
package com.Martin;

import java.util.List;
import java.util.Random;
import java.util.*;
import java.io.IOException;  
import java.net.URL;  
import java.util.ArrayList;  
import java.util.Enumeration;  
import java.util.List; 
import java.io.File;
import java.util.HashMap;


public class HumanFactory{

	private static HashMap<String,Human> humans = new HashMap<String,Human>();

	public static Human createHuman(Class c){
		Human human = null;
		
		try{
			// if(humans.containsKey(c.getSimpleName())){
			// 	human = humans.get(c.getSimpleName());
			// }else{
				human = (Human)Class.forName(c.getName()).newInstance();
			//	humans.put(c.getSimpleName(),human);
			//}

			
		}catch(InstantiationException e){
			System.out.println("必需指定人种颜色");
		}catch(IllegalAccessException e){
			System.out.println("定义人种错误");
		}catch(ClassNotFoundException e){
			System.out.println("这个人种找不到");
		}
		return human;
	}

	public static Human createHuman(){

		Human human = null;
		List<Class> concreteHumanList = getAllClassByInterface(Human.class);
		Random random = new Random();

		int rand = random.nextInt(concreteHumanList.size());
		human = createHuman(concreteHumanList.get(rand));
		return human;

	}

	public static List<Class> getAllClassByInterface(Class c) {  
  
        // 给一个接口，返回这个接口的所有实现类  
        List<Class> returnClassList = new ArrayList<Class>();// 返回结果  
        // 如果不是一个接口，则不做处理  
        if (c.isInterface()) {  
            String packageName = c.getPackage().getName();// 获得当前包名  
            try {  
                List<Class> allClass = getClasses(packageName);// 获得当前包下以及包下的所有类  
                for (int i = 0; i < allClass.size(); i++) {  
                    if (c.isAssignableFrom(allClass.get(i))) {// 判断是不是一个接口  
                        if (!c.equals(allClass.get(i))) {// 本身加不进去  
                            returnClassList.add(allClass.get(i));  
  
                        }  
                    }  
                }  
            } catch (ClassNotFoundException e) {  
                // TODO Auto-generated catch block  
                e.printStackTrace();  
            } catch (IOException e) {  
                // TODO: handle exception  
                e.printStackTrace();  
            }  
        }  
        return returnClassList;  
  
    } 

    // 从一个包中查找出所有类,在jar包中不能查找  
    private static List<Class> getClasses(String packageName)  
            throws IOException, ClassNotFoundException {  
        ClassLoader classLoader = Thread.currentThread()  
                .getContextClassLoader();  
        String path = packageName.replace('.', '/');  
        Enumeration<URL> resources = classLoader.getResources(path);  
        List<File> dirs = new ArrayList<File>();  
        while (resources.hasMoreElements()) {  
            URL resource = resources.nextElement();  
            dirs.add(new File(resource.getFile()));  
        }  
        ArrayList<Class> classes = new ArrayList<Class>();  
        for (File directory : dirs) {  
            classes.addAll(findClasses(directory, packageName));  
        }  
        return classes;  
    }  

      private static List<Class> findClasses(File directory, String packageName)  
            throws ClassNotFoundException {  
        List<Class> classes = new ArrayList<Class>();  
        if (!directory.exists()) {  
            return classes;  
        }  
        File[] files = directory.listFiles();  
        for (File file : files) {  
            if (file.isDirectory()) {  
                assert !file.getName().contains(".");  
                classes.addAll(findClasses(file, packageName + '.'  
                        + file.getName()));  
            } else if (file.getName().endsWith(".class")) {  
                classes.add(Class.forName(packageName  
                        + "."  
                        + file.getName().substring(0,  
                                file.getName().length() - 6)));  
            }  
        }  
        return classes;  
    }  
}