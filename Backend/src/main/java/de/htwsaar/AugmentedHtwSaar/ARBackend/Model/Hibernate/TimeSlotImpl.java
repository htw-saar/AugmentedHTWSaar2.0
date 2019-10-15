package de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Hibernate;

import de.htwsaar.AugmentedHtwSaar.ARBackend.Model.AbstractDao;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Interface.TimeSlot;

import java.util.Date;

/**
 * @author Peter Klein, Robin Bachmann, Matthias Tritt
 */
public class TimeSlotImpl extends AbstractDao implements TimeSlot {
    private Date From;
    private Date To;
    private String Label;

    public Date getFrom() {
        return From;
    }

    public void setFrom(Date from) {
        From = from;
    }

    public Date getTo() {
        return To;
    }

    public void setTo(Date to) {
        To = to;
    }

    public String getLabel() {
        return Label;
    }

    public void setLabel(String label) {
        Label = label;
    }

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 31 * hash + (From == null ? 0 : From.hashCode());
        hash = 31 * hash + (To == null ? 0 : To.hashCode());
        hash = 31 * hash + (Label == null ? 0 : Label.hashCode());
        return hash;
    }
}
