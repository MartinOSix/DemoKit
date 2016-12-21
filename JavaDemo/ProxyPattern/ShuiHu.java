public class ShuiHu{

	public interface KinWomen{
		public void makeEyesWithMan();
		public void happyWithMan(String str);
	}

	public class PanJinLian implements KinWomen{
		public void happyWithMan(String str){
			System.out.println("pan method happyWithMan"+str);
		}
		public void makeEyesWithMan(){
			System.out.println("pan method makeEyesWithMan");
		}
	}

	public class WangPo implements KinWomen{

		private KinWomen kinWomen;

		public WangPo(){
			this.kinWomen = new PanJinLian();
		}

		public void happyWithMan(String str){
			this.kinWomen.happyWithMan(str);
		}

		public void makeEyesWithMan(){
			this.kinWomen.makeEyesWithMan();
		}

	}


	public static void main(String[] args) {
		
		ShuiHu shuihu = new ShuiHu();
		WangPo wang = shuihu.new WangPo();

		wang.makeEyesWithMan();
		wang.happyWithMan("westDoor");
	}

}