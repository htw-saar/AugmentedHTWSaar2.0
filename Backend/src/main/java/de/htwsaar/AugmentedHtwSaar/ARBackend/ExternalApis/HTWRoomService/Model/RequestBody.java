package de.htwsaar.AugmentedHtwSaar.ARBackend.ExternalApis.HTWRoomService.Model;

/**
 * @author Peter Klein, Robin Bachmann, Matthias Tritt
 * <p>
 * Genric Format for "htw-Saar Raumservice Api" submitted api-responses
 */
public class RequestBody<T> extends DumpableObject {
    private Boolean success;
    private String status;
    private Integer count;
    private T recordset;

    public Boolean getSuccess() {
        return success;
    }

    public void setSuccess(Boolean success) {
        this.success = success;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getCount() {
        return count;
    }

    public void setCount(Integer count) {
        this.count = count;
    }


    public T getRecordset() {
        return recordset;
    }

    public void setRecordset(T recordset) {
        this.recordset = recordset;
    }

    public Boolean hasData() {
        return recordset != null;
    }


}
