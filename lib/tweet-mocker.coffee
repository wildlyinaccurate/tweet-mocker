# TweetMocker attempts to mock the way Twitter parses text to create a
# tweet. Its itended use is to create Tweet previews.
#
# @author Joseph Wynn <joseph.wynn@rightster.com>
class TweetMocker

  LINK_PATTERN: /// (
    [^\s]+//    # Non-space characters followed by // for the protocol
    [^\s]+\.      # Sub- or second-level domain
    [^\s]+\.      # Sub-, second-level, or top-level domain
    [^\s]+        # The rest of it
  ) ///
  
  USERNAME_PATTERN: /@[^\s]+/g
  
  HASHTAG_PATTERN: /#[^\s]+/g
  
  # Auto-link a string, replacing all URLs and Twitter tokens with <a> elements
  autolink: (string) ->
    string = @parseHashTags string
    string = @parseUsernames string
    string = @parseUrls string
    
    string.substr 0, 159

  # Parses a string and converts #hashtags to <a> elements
  parseHashTags: (string) ->
    string.replace @HASHTAG_PATTERN, (hashtag) ->
      "<a href='#'>#{hashtag}</a>"
      
  # Parses a string and converts @usernames to <a> elements
  parseUsernames: (string) ->
    string.replace @USERNAME_PATTERN, (username) ->
      "<a href='#'>#{username}</a>"

  # Parses a string and converts URL-like sustrings to <a> elements
  parseLinks: (string) ->
    maxPathLength = 14
    maxDomainLength = 37

    text.replace @LINK_PATTERN, (url) ->
      "<a href='#{url}'>#{url}</a>"
      
mocker = new TweetMocker()

window.TweetMocker = mocker if window is defined
module.exports.TweetMocker = mocker if typeof module is 'object'
