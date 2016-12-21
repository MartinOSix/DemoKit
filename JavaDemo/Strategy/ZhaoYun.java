



public class ZhaoYun{

		public interface IStrategy{
		//锦囊算法
		public void operate();
	}

	public class BackDoor implements IStrategy{
		public void operate(){
			System.out.println("找乔国老，让吴国太给孙权施加压力");
		}
	}

	public class GicenGreenLight implements IStrategy{
		public void operate(){
			System.out.println("求吴国太开个绿灯，放行");
		}
	}

	public class BlockEnemy implements IStrategy{
		public void operate(){
			System.out.println("孙夫人断后，挡住追兵");
		}
	}

	public class Context{
		private IStrategy strategy;
		public Context(IStrategy strategy){
			this.strategy = strategy;
		}

		public void operate(){
			this.strategy.operate();
		}
	}

	public static void main(String[] args) {
		Context context;
		ZhaoYun zhao = new ZhaoYun();
		System.out.println("---刚到吴国拆第一个---");
		context = zhao.new Context(zhao.new BackDoor());//拿到妙计
		context.operate();//拆开执行
		System.out.println("\n\n\n\n\n");

		System.out.println("---刘备乐不思蜀了，拆第二个---");
		context = zhao.new Context(zhao.new GicenGreenLight());
		context.operate();
		System.out.println("\n\n\n\n\n");

		System.out.println("---孙权追兵来了，咋办，拆第三个锦囊----");
		context = zhao.new Context(zhao.new BlockEnemy());
		context.operate();
		System.out.println("---end----");
	}
}

