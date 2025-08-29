package mvc.model;

import java.sql.Timestamp;

public class CommentDTO {
    private int comment_id;
    private int post_num;
    private String user_id;
    private String content;
    private Timestamp created_at;
    private Timestamp updated_at;
    private String deleted;

    public int getComment_id() {
        return comment_id;
    }
    public void setComment_id(int comment_id) {
        this.comment_id = comment_id;
    }

    public int getPost_num() {
        return post_num;
    }
    public void setPost_num(int post_num) {
        this.post_num = post_num;
    }

    public String getUser_id() {
        return user_id;
    }
    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }

    public String getContent() {
        return content;
    }
    public void setContent(String content) {
        this.content = content;
    }

    public Timestamp getCreated_at() {
        return created_at;
    }
    public void setCreated_at(Timestamp created_at) {
        this.created_at = created_at;
    }

    public Timestamp getUpdated_at() {
        return updated_at;
    }
    public void setUpdated_at(Timestamp updated_at) {
        this.updated_at = updated_at;
    }

    public String getDeleted() {
        return deleted;
    }
    public void setDeleted(String deleted) {
        this.deleted = deleted;
    }
}
