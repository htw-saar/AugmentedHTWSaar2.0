package de.htwsaar.AugmentedHtwSaar.ARBackend.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerMapping;

import java.sql.SQLException;

/**
 * @author Peter Klein, Robin Bachmann, Matthias Tritt
 * <p>
 * Service controller for the route path
 */
@RestController
public class RouteService {
    @Autowired
    public RequestMappingHandlerMapping requestMappingHandlerMapping;

    @RequestMapping(value = "/endpoints", method = RequestMethod.GET)
    public @ResponseBody
    Object showEndpointsAction() throws SQLException {
        return requestMappingHandlerMapping.getHandlerMethods().keySet().stream().map(t ->
                (t.getMethodsCondition().getMethods().size() == 0 ? "GET" : t.getMethodsCondition().getMethods().toArray()[0]) + " " +
                        t.getPatternsCondition().getPatterns().toArray()[0]
        ).toArray();
    }
}
