(function() {

    /**
     * TweetMocker attempts to mock the way Twitter parses text to create a
     * tweet. Its itended use is to create Tweet previews.
     *
     * @author Joseph Wynn <joseph.wynn@rightster.com>
     */
    function TweetMocker() {}

    /**
     * Explanation:
     *
     *  1+ non-space characters (protocol)
     *  // (how we know it's a URL)
     *  1+ non-space characters (sub- or second-level- domain)
     *  dot
     *  1+ non-space characters (sub-, secont-level-, or top-level- domain)
     *  1+ non-space characters (could be the rest of a domain, or a path, hash, etc)
     */
    TweetMocker.prototype.LINK_PATTERN = /[^\s]+\/\/[^\s]+\.[^\s]+\.[^\s]+/g;

    TweetMocker.prototype.USERNAME_PATTERN = /@[^\s]+/g;
    TweetMocker.prototype.HASHTAG_PATTERN = /#[^\s]+/g;

    /**
     * Creates a mock tweet from the given text
     * @param  {String} tweet
     * @return {String}
     */
    TweetMocker.prototype.create = function(tweet) {
        tweet = this.parseHashTags(tweet);

        return tweet.substr(0, 159);
    };

    /**
     * Helper function to create an <a> element. Returns the element as a string.
     * @param  {String} href
     * @param  {String} text
     * @return {String}
     */
    var getLinkHTML = function TweetMockerGetLinkHTML(href, text) {
        var a = document.createElement('a');

        a.href = href;
        a.textContent = text;

        return a.outerHTML;
    };

    /**
     * Parses a string and converts #hashtags to <a> elements
     * @param  {String} text
     * @return {String}
     */
    TweetMocker.prototype.parseHashTags = function(text) {
        return text.replace(this.HASHTAG_PATTERN, function(tag) {
            return getLinkHTML('#', tag);
        });
    };

    /**
     * Parses a string and converts @usernames to <a> elements
     * @param  {String} text
     * @return {String}
     */
    TweetMocker.prototype.parseUsernames = function(text) {
        return text.replace(this.USERNAME_PATTERN, function(username) {
            return getLinkHTML('#', username);
        });
    };

    /**
     * Parses a string and converts URLs to <a> elements
     * @param  {String} text
     * @return {String}
     */
    TweetMocker.prototype.parseLinks = function(text) {
        var maxPathLength = 14;
        var maxDomainLength = 37;

        return text.replace(this.LINK_PATTERN, function(url) {
            var link = url;

            return getLinkHTML(url, link);
        });
    };

    window.TweetMocker = new TweetMocker();

})();
