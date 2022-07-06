public class LEResponse {
	public Body Body;
	public Header Header;
    
	public class Header{
		public Integer Code;
		public String Status;
		public List<Errors> Errors;
	}
    
    public class Errors{
        public string ErrorCode;
        public string ErrorType;
        public string Message;   
    }

	public class Body{
		//public String NextDueDate;
        //public String NextLEDate;
        //public String maturityDate;
		public Integer intErrorNumber;
		public String strErrorMessage;
        public String strStatus;
	}

	public static LEResponse parse(String jsonInput){
        return (LEResponse)JSON.deserialize(jsonInput,LEResponse.class);
		//return (LEResponse)System.JSON.deserialize(json, LEResponse.class);
	}
}