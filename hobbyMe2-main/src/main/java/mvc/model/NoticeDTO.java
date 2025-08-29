package mvc.model;

import java.util.Date;

public class NoticeDTO {
    private int notice_num;
    private String title;
    private String content;
    private String category;
    private Date created_date;

    private String coupon_content;
    private boolean couponIssued;

    private String startDate;
    private String endDate;

    private boolean expired;
    
    private int coupon_value;
    private String coupon_type;
    private String couponStart;
    private String couponEnd;

    // 기본 getter/setter
    public int getNotice_num() {
        return notice_num;
    }

    public void setNotice_num(int notice_num) {
        this.notice_num = notice_num;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public Date getCreated_date() {
        return created_date;
    }

    public void setCreated_date(Date created_date) {
        this.created_date = created_date;
    }

    public String getCoupon_content() {
        return coupon_content;
    }

    public void setCoupon_content(String coupon_content) {
        this.coupon_content = coupon_content;
    }

    // camelCase for JSTL or DAO
    public String getCouponContent() {
        return coupon_content;
    }

    public void setCouponContent(String coupon_content) {
        this.coupon_content = coupon_content;
    }

    public boolean isCouponIssued() {
        return couponIssued;
    }

    public void setCouponIssued(boolean couponIssued) {
        this.couponIssued = couponIssued;
    }

    // ✅ 이벤트 시작일 getter/setter
    public String getStartDate() {
        return startDate;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    // ✅ 이벤트 종료 여부
    public boolean isExpired() {
        return expired;
    }

    public void setExpired(boolean expired) {
        this.expired = expired;
    }
    
    public int getCoupon_value() { return coupon_value; }
    public void setCoupon_value(int coupon_value) { this.coupon_value = coupon_value; }

    public String getCoupon_type() { return coupon_type; }
    public void setCoupon_type(String coupon_type) { this.coupon_type = coupon_type; }

    public String getCouponStart() { return couponStart; }
    public void setCouponStart(String couponStart) { this.couponStart = couponStart; }

    public String getCouponEnd() { return couponEnd; }
    public void setCouponEnd(String couponEnd) { this.couponEnd = couponEnd; }

}
