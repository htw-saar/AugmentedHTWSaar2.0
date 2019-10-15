package de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Hibernate;

import de.htwsaar.AugmentedHtwSaar.ARBackend.Model.AbstractDao;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Interface.Favorite;

import javax.persistence.ElementCollection;
import javax.persistence.Entity;
import javax.persistence.OneToOne;
import java.util.Set;

/**
 * @author Peter Klein, Robin Bachmann, Matthias Tritt
 */
@Entity
public class FavoriteImpl extends AbstractDao implements Favorite {
    @OneToOne
    private UserImpl user;
    @ElementCollection
    private Set<String> favorites;

    public UserImpl getUser() {
        return user;
    }

    public void setUser(UserImpl user) {
        this.user = user;
    }

    public Set<String> getFavorites() {
        return favorites;
    }

    public void setFavorites(Set<String> favorites) {
        this.favorites = favorites;
    }

    public void addFavorite(String favorite) {
        favorites.add(favorite);
    }

    public void removeFavorite(String favorite) {
        favorites.remove(favorite);
    }
}
