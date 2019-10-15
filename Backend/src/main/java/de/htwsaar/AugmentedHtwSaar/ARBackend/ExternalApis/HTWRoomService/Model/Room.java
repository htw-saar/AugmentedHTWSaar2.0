package de.htwsaar.AugmentedHtwSaar.ARBackend.ExternalApis.HTWRoomService.Model;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import de.htwsaar.AugmentedHtwSaar.ARBackend.ExternalApis.HTWRoomService.Decoder.NumericBooleanDeserializer;

import java.util.Map;

/**
 * @author Peter Klein, Robin Bachmann, Matthias Tritt
 * <p>
 * Represents a room as submitted by the "Raumserviec Api"
 */
public class Room extends DumpableObject {
    private String raumnr;
    private String datum;
    private String von;
    private String bis;
    private String veranstaltung;
    private String stg;
    private Integer stgsem;
    private String fakultaet;
    @JsonDeserialize(using = NumericBooleanDeserializer.class)
    private boolean einzeltermin;
    @JsonDeserialize(using = NumericBooleanDeserializer.class)
    private Boolean s1;
    @JsonDeserialize(using = NumericBooleanDeserializer.class)
    private Boolean s2;
    @JsonDeserialize(using = NumericBooleanDeserializer.class)
    private Boolean s3;
    @JsonDeserialize(using = NumericBooleanDeserializer.class)
    private Boolean s4;
    @JsonDeserialize(using = NumericBooleanDeserializer.class)
    private Boolean s5;
    @JsonDeserialize(using = NumericBooleanDeserializer.class)
    private Boolean s6;
    @JsonDeserialize(using = NumericBooleanDeserializer.class)
    private Boolean stundenplan;
    @JsonDeserialize(using = NumericBooleanDeserializer.class)
    private Boolean pruefung;
    private Integer semester;
    private Map<String, Object> ausstattung;

    public String getRaumnr() {
        return raumnr;
    }

    public void setRaumnr(String raumnr) {
        this.raumnr = raumnr;
    }

    public String getDatum() {
        return datum;
    }

    public void setDatum(String datum) {
        this.datum = datum;
    }

    public String getVon() {
        return von;
    }

    public void setVon(String von) {
        this.von = von;
    }

    public String getBis() {
        return bis;
    }

    public void setBis(String bis) {
        this.bis = bis;
    }

    public String getVeranstaltung() {
        return veranstaltung;
    }

    public void setVeranstaltung(String veranstaltung) {
        this.veranstaltung = veranstaltung;
    }

    public String getStg() {
        return stg;
    }

    public void setStg(String stg) {
        this.stg = stg;
    }

    public Integer getStgsem() {
        return stgsem;
    }

    public void setStgsem(Integer stgsem) {
        this.stgsem = stgsem;
    }

    public String getFakultaet() {
        return fakultaet;
    }

    public void setFakultaet(String fakultaet) {
        this.fakultaet = fakultaet;
    }

    public Boolean getEinzeltermin() {
        return einzeltermin;
    }

    public void setEinzeltermin(Boolean einzeltermin) {
        this.einzeltermin = einzeltermin;
    }

    public Boolean getS1() {
        return s1;
    }

    public void setS1(Boolean s1) {
        this.s1 = s1;
    }

    public Boolean getS2() {
        return s2;
    }

    public void setS2(Boolean s2) {
        this.s2 = s2;
    }

    public Boolean getS3() {
        return s3;
    }

    public void setS3(Boolean s3) {
        this.s3 = s3;
    }

    public Boolean getS4() {
        return s4;
    }

    public void setS4(Boolean s4) {
        this.s4 = s4;
    }

    public Boolean getS5() {
        return s5;
    }

    public void setS5(Boolean s5) {
        this.s5 = s5;
    }

    public Boolean getS6() {
        return s6;
    }

    public void setS6(Boolean s6) {
        this.s6 = s6;
    }

    public Boolean getStundenplan() {
        return stundenplan;
    }

    public void setStundenplan(Boolean stundenplan) {
        this.stundenplan = stundenplan;
    }

    public Boolean getPruefung() {
        return pruefung;
    }

    public void setPruefung(Boolean pruefung) {
        this.pruefung = pruefung;
    }

    public Integer getSemester() {
        return semester;
    }

    public void setSemester(Integer semester) {
        this.semester = semester;
    }

    public Map<String, Object> getAusstattung() {
        return ausstattung;
    }

    public void setAusstattung(Map<String, Object> ausstattung) {
        this.ausstattung = ausstattung;
    }
}
