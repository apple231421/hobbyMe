package mvc.model;

import java.sql.Date;

public class CouponDTO {
    private int couponNum;               // 쿠폰 고유 번호 (PK)
    private String userId;               // 쿠폰을 소유하거나 생성한 유저 ID
    private String couponContent;        // 쿠폰 코드
    private int couponValue;             // 쿠폰 금액 또는 퍼센트
    private Date startDate;              // 유효 시작일
    private Date endDate;                // 유효 종료일
    private String couponState;          // 상태: A(사용 가능), E(만료), C(소진)
    private String couponDeleted;        // 삭제 여부: N(기본), Y
    private String couponType;           // 종류: P(포인트), D(할인)

    // Getter / Setter
    public int getCouponNum() {
        return couponNum;
    }

    public void setCouponNum(int couponNum) {
        this.couponNum = couponNum;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
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

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getCouponState() {
        return couponState;
    }

    public void setCouponState(String couponState) {
        this.couponState = couponState;
    }

    public String getCouponDeleted() {
        return couponDeleted;
    }

    public void setCouponDeleted(String couponDeleted) {
        this.couponDeleted = couponDeleted;
    }

    public String getCouponType() {
        return couponType;
    }

    public void setCouponType(String couponType) {
        this.couponType = couponType;
    }
}
