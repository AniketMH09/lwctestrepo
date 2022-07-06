public class PymtExtResponse {

	public Header Header;

	public class Header {
		public Integer Code;
		public String Status;
	}

	
	public static PymtExtResponse parse(String json) {
		return (PymtExtResponse) System.JSON.deserialize(json, PymtExtResponse.class);
	}
}