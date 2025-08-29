package mvc.model;

public class FaqDTO {
    private int faq_num;
    private String title;
    private String content;
    private String category;
    private String created_date;
    private String deleted;

    public int getFaq_num() { return faq_num; }
    public void setFaq_num(int faq_num) { this.faq_num = faq_num; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getCreated_date() { return created_date; }
    public void setCreated_date(String created_date) { this.created_date = created_date; }

    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }
}
