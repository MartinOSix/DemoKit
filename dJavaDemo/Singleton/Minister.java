public class Minister{

	public static class Emperor{

		private static Emperor emperor = null;//定义一个皇帝放在那里

		private Emperor(){

		}

		public static Emperor getInstance(){
			if (emperor == null) {
				emperor = new Emperor();
			}
			return emperor;
		}

		public static void emperorInfo(){
			System.out.println("我是皇帝某某");
		} 


	}




	public static void main(String[] args) {
		
		Minister minister = new Minister();
		Emperor emp = Emperor.getInstance();
		emp.emperorInfo();

		Emperor emp2 = Emperor.getInstance();
		emp2.emperorInfo();

		Emperor emp3 = Emperor.getInstance();
		emp3.emperorInfo();

	}

}