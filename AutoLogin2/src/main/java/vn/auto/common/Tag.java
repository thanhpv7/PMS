package vn.auto.common;

public class Tag {
    private int openTagPos;
    private int endTagPos;

    public Tag(int openTagPos, int endTagPos) {
        super();
        this.openTagPos = openTagPos;
        this.endTagPos = endTagPos;
    }

    public int getOpenTagPos() {
        return openTagPos;
    }

    public void setOpenTagPos(int openTagPos) {
        this.openTagPos = openTagPos;
    }

    public int getEndTagPos() {
        return endTagPos;
    }

    public void setEndTagPos(int endTagPos) {
        this.endTagPos = endTagPos;
    }
}
