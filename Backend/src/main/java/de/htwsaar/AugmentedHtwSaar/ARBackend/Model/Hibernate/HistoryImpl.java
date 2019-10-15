package de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Hibernate;

import de.htwsaar.AugmentedHtwSaar.ARBackend.Model.AbstractDao;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Interface.History;

import javax.persistence.ElementCollection;
import javax.persistence.Entity;
import javax.persistence.OneToOne;
import java.time.Instant;
import java.util.Map;

/**
 * @author Peter Klein, Robin Bachmann, Matthias Tritt
 */
@Entity
public class HistoryImpl extends AbstractDao implements History {
    @OneToOne
    private UserImpl user;
    @ElementCollection
    private Map<Instant, String> history;

    private Instant timestamp;

    public UserImpl getUser() {
        return user;
    }

    public void setUser(UserImpl user) {
        this.user = user;
    }

    public Map<Instant, String> getHistory() {
        return history;
    }

    public void setHistory(Map<Instant, String> historyEntry) {
        this.history = historyEntry;
    }

    public void addHistory(String room) {
        timestamp = Instant.now();
        history.put(timestamp, room);
    }


    public Instant getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Instant timestamp) {
        this.timestamp = timestamp;
    }
}
