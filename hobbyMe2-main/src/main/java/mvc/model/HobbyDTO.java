package mvc.model;

import java.sql.Date;

public class HobbyDTO {
	private int UserNum;
	private String userId;
	private String password;
	private String name;
	private String email;
	private String phone;
	private String address;
	private String gender;
	private Date birthdate;
	private String classes;
	private String deleted;
	private String grade;
	private String hostContent;
	private String hostTitle;
	private String hostFile;
	private String hostState;
	private int categoryNum;
	private String categoryName;
	private int myBoardNum;
	private String myBoardTitle;
	private String myBoardReservation;
	private String myBoardEndDate;
	private int myBoardPrice;
	private String myId;
	private String myBoardState;
	private int myPayNum;
	private String myPayTitle;
	private String myPayReservation;
	private String myPayEndDate;
	private String myPayState;
	private String couponContent;
	private int couponValue;
	private String couponState;
	private String couponStart;
	private String couponEnd;
	private int couponNum;
	private String couponDel;
	private String couponType;
	
	public String getCouponType() {
		return couponType;
	}
	public void setCouponType(String couponType) {
		this.couponType = couponType;
	}
	public String getCouponDel() {
		return couponDel;
	}
	public void setCouponDel(String couponDel) {
		this.couponDel = couponDel;
	}
	public String getCouponContent() {
		return couponContent;
	}
	public void setCouponContent(String couponContent) {
		this.couponContent = couponContent;
	}
	public int getCouponValue() {
		return couponValue;
	}
	public void setCouponValue(int couponValue) {
		this.couponValue = couponValue;
	}
	public String getCouponState() {
		return couponState;
	}
	public void setCouponState(String couponState) {
		this.couponState = couponState;
	}
	public String getCouponStart() {
		return couponStart;
	}
	public void setCouponStart(String couponStart) {
		this.couponStart = couponStart;
	}
	public String getCouponEnd() {
		return couponEnd;
	}
	public void setCouponEnd(String couponEnd) {
		this.couponEnd = couponEnd;
	}
	public int getCouponNum() {
		return couponNum;
	}
	public void setCouponNum(int couponNum) {
		this.couponNum = couponNum;
	}
	public String getMyPayDel() {
		return myPayDel;
	}
	public void setMyPayDel(String myPayDel) {
		this.myPayDel = myPayDel;
	}
	private String myPayDel;
	
	public String getMyPayState() {
		return myPayState;
	}
	public void setMyPayState(String myPayState) {
		this.myPayState = myPayState;
	}
	public int getMyPayNum() {
		return myPayNum;
	}
	public void setMyPayNum(int myPayNum) {
		this.myPayNum = myPayNum;
	}
	public String getMyPayTitle() {
		return myPayTitle;
	}
	public void setMyPayTitle(String myPayTitle) {
		this.myPayTitle = myPayTitle;
	}
	public String getMyPayReservation() {
		return myPayReservation;
	}
	public void setMyPayReservation(String myPayReservation) {
		this.myPayReservation = myPayReservation;
	}
	public String getMyPayEndDate() {
		return myPayEndDate;
	}
	public void setMyPayEndDate(String myPayEndDate) {
		this.myPayEndDate = myPayEndDate;
	}
	public String getMyBoardState() {
		return myBoardState;
	}
	public void setMyBoardState(String myBoardState) {
		this.myBoardState = myBoardState;
	}
	public String getMyId() {
		return myId;
	}
	public void setMyId(String myId) {
		this.myId = myId;
	}
	public int getMyBoardNum() {
		return myBoardNum;
	}
	public void setMyBoardNum(int myBoardNum) {
		this.myBoardNum = myBoardNum;
	}
	public String getMyBoardTitle() {
		return myBoardTitle;
	}
	public void setMyBoardTitle(String myBoardTitle) {
		this.myBoardTitle = myBoardTitle;
	}
	public String getMyBoardReservation() {
		return myBoardReservation;
	}
	public void setMyBoardReservation(String myBoardReservation) {
		this.myBoardReservation = myBoardReservation;
	}
	public String getMyBoardEndDate() {
		return myBoardEndDate;
	}
	public void setMyBoardEndDate(String myBoardEndDate) {
		this.myBoardEndDate = myBoardEndDate;
	}
	public int getMyBoardPrice() {
		return myBoardPrice;
	}
	public void setMyBoardPrice(int myBoardPrice) {
		this.myBoardPrice = myBoardPrice;
	}
	public int getCategoryNum() {
		return categoryNum;
	}
	public void setCategoryNum(int categoryNum) {
		this.categoryNum = categoryNum;
	}
	public String getCategoryName() {
		return categoryName;
	}
	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}
	public String getHostState() {
		return hostState;
	}
	public void setHostState(String hostState) {
		this.hostState = hostState;
	}
	public String getGrade() {
		return grade;
	}
	public void setGrade(String grade) {
		this.grade = grade;
	}
	public String getHostContent() {
		return hostContent;
	}
	public void setHostContent(String hostContent) {
		this.hostContent = hostContent;
	}
	public String getHostTitle() {
		return hostTitle;
	}
	public void setHostTitle(String hostTitle) {
		this.hostTitle = hostTitle;
	}
	public String getHostFile() {
		return hostFile;
	}
	public void setHostFile(String hostFile) {
		this.hostFile = hostFile;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public Date getBirthdate() {
		return birthdate;
	}
	public void setBirthdate(Date birthdate) {
		this.birthdate = birthdate;
	}
	public int getUserNum() {
		return UserNum;
	}
	public void setUserNum(int userNum) {
		UserNum = userNum;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public String getClasses() {
		return classes;
	}
	public void setClasses(String classes) {
		this.classes = classes;
	}
	public String getDeleted() {
		return deleted;
	}
	public void setDeleted(String deleted) {
		this.deleted = deleted;
	}
}
