package de.htwsaar.AugmentedHtwSaar.ARBackend.Authenticators;

import de.htwsaar.AugmentedHtwSaar.ARBackend.ConfigUtils.AugmentedBackendSpringProperties;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Logging.Loggable;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Hibernate.UserImpl;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Interface.User;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

/**
 * @author Peter Klein, Robin Bachmann, Matthias Tritt
 * <p>
 * This filter checks wether the request needs to be authentiated or ignored
 * Also provides a small helper function to obtain the authenticated users
 * details
 */
public class HMACAuthenticationFilter extends OncePerRequestFilter implements Loggable {

    private static UserImpl user;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private AugmentedBackendSpringProperties augmentedBackendSpringProperties;

    public static UserImpl getUser() {
        return user;
    }

    public static void setUser(UserImpl user) {
        HMACAuthenticationFilter.user = user;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        String requestUri = request.getRequestURI();
        final AuthenticationHeader authHeader = extractAuthenticationHeader(request);

        for (String filterUri : augmentedBackendSpringProperties.getSkipAuthenticationForPaths()) {
            Boolean filterResult = requestUri.startsWith(filterUri);
            trace("Checking filter '{}' for uri '{}' (filter={})", filterUri, requestUri, filterResult);
            if (requestUri.startsWith(filterUri) && authHeader == null) {
                trace("Request triggers filter and has NO authentication header. Allowing access ...");
                filterChain.doFilter(request, response);
                return;
            }
        }

        trace("Will authenticate request");
        if (authHeader == null) {
            // invalid authorization token
            logger.warn("Missing authorization header");
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        } else {
            trace("Extracted authorization header is '{}'", authHeader);
        }

        if (!HMACUtil.isSupportedAlgorithm(authHeader.getAlgorithm()))
            throw new RuntimeException("Invalid algorithm");
        if (!HMACUtil.isValidNonce(authHeader.getNonce()))
            throw new RuntimeException("Invalid Nonce");
        if (!HMACUtil.isValidTimestamp(authHeader.getTimestamp()))
            throw new RuntimeException("Invalid Timestamp");

        final User authenticationgUser = userRepository.findUserByapiUser(authHeader.getAPIKey());

        if (authenticationgUser == null) {
            // invalid digest
            logger.error("No such user " + authHeader.getAPIKey());
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid authorization data");
            return;
        }

        final String apiSecret = authenticationgUser.getApiSecret();
        if (apiSecret == null) {
            // invalid digest
            logger.error("Invalid API key");
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid authorization data");
            return;
        }

        String signatureData = List.of(
                request.getRequestURI(),
                authenticationgUser.getApiUser(),
                authHeader.getNonce(),
                authHeader.getTimestamp().toString()
                )
                .parallelStream()
                .collect(Collectors.joining(""));

        info("Creating digest for '{}'", signatureData);

        try {
            if (!HMACUtil.digestEquals(authHeader.getDigest(), HMACUtil.calculateDigest(authHeader.getAlgorithm(), signatureData, authenticationgUser.getApiSecret()))) {
                // invalid digest
                logger.error("Invalid digest");
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid authorization data");
                return;
            }
        } catch (InvalidKeyException e) {
            e.printStackTrace();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }

        HMACAuthenticationFilter.setUser((UserImpl) authenticationgUser);
        filterChain.doFilter(request, response);
    }

    private AuthenticationHeader extractAuthenticationHeader(HttpServletRequest httpServletRequest) {
        // <ALGO>:<USER>:<NONCE>:<TIME>:<DIGEST>
        /*
        digest = hmac(
            request.getRequestURI(),
            authenticationgUser.getApiUser(),
            authHeader.getNonce(),
            authHeader.getTimestamp().toString()
         */
        Pattern AUTHORIZATION_HEADER_PATTERN = Pattern.compile("^(\\w+)\\:(\\S+)\\:(\\S+)\\:(\\d+)\\:([\\S]+)$");
        final String authHeader = httpServletRequest.getHeader(HttpHeaders.AUTHORIZATION);
        if (authHeader == null) {
            warn("Flagging HttpHeaders.AUTHORIZATION as faulty. Header not set");
            // invalid authorization token
            return null;
        }
        final Matcher authHeaderMatcher = AUTHORIZATION_HEADER_PATTERN.matcher(authHeader);
        if (!authHeaderMatcher.matches()) {
            warn("Flagging HttpHeaders.AUTHORIZATION as faulty. Header does not match required pattern");
            return null;
        }
        final String Algorithm = authHeaderMatcher.group(1);
        final String APIKey = authHeaderMatcher.group(2);
        final String Nonce = authHeaderMatcher.group(3);
        final Long Time = Long.parseLong(authHeaderMatcher.group(4));
        final String Digest = authHeaderMatcher.group(5);

        return new AuthenticationHeader(Algorithm, APIKey, Nonce, Time, Digest);
    }

    public UserRepository getUserRepository() {
        return userRepository;
    }

    public void setUserRepository(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public AugmentedBackendSpringProperties getAugmentedBackendSpringProperties() {
        return augmentedBackendSpringProperties;
    }

    public void setAugmentedBackendSpringProperties(AugmentedBackendSpringProperties augmentedBackendSpringProperties) {
        this.augmentedBackendSpringProperties = augmentedBackendSpringProperties;
    }
}
