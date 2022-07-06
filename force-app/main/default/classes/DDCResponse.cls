public class DDCResponse{
	public Body Body;
	public Header Header;
	public class Header{
		public Integer Code;
		public String Status;
		public Object Errors;
	}

	public class Body{
		public String NextDueDate;
		public Integer intErrorNumber;
		public String strErrorMessage;
	}

	public static DDCResponse parse(String json){
		return (DDCResponse)System.JSON.deserialize(json, DDCResponse.class);
	}
}