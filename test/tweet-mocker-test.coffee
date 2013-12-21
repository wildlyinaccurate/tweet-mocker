describe 'TweetMocker', ->

  # Helper function to create strings of various lengths.
  # The string is composed of periods (.)
  create_string = (length) ->
    Array(length).join '.'

  describe '.create()', ->

    it 'should trim long strings to 160 characters', ->
      expect(TweetMocker.create(create_string(159))).toBe create_string(159)
      expect(TweetMocker.create(create_string(160))).toBe create_string(160)
      expect(TweetMocker.create(create_string(161))).toBe create_string(160)
      expect(TweetMocker.create(create_string(200))).toBe create_string(160)
      expect(TweetMocker.create(create_string(10000))).toBe create_string(160)

    it 'should correctly handle a hash in a URL', ->
      tweet = TweetMocker.create 'I like http://www.foo.com/this#that also #foo'
      mock = setFixtures tweet
      links = mock.find 'a'

      expect(links.length).toBe 2
      expect(links[0].innerHTML).toBe 'foo.com/this#that'
      expect(links[1].innerHTML).toBe '#foo'

  describe '.parseHashTags()', ->

    it 'should wrap hashtags in an <a> element', ->
      tweet = TweetMocker.parseHashTags 'I like #foo and #bar'
      mock = setFixtures tweet
      links = mock.find 'a'

      expect(mock.text()).toBe 'I like #foo and #bar'
      expect(links.length).toBe 2
      expect(links[0].innerHTML).toBe '#foo'
      expect(links[1].innerHTML).toBe '#bar'

  describe '.parseLinks()', ->

    # Helper function to reduce duplication
    testParseLinks = (link, expected), ->
      tweet = TweetMocker.parseLinks link
      mock = setFixtures tweet
      link = mock.find('a')[0]

      expect(link.href).toBe link
      expect(link.innerHTML).toBe expected

    it 'should wrap URLs in an <a> element and shorten the text', ->
      testParseLinks 'http://www.foo.com', 'foo.com'
      testParseLinks 'http://www.foo.com/bar', 'foo.com/bar'
      testParseLinks 'http://www.foo.com/bar#baz', 'foo.com/bar#baz'
      testParseLinks 'http://lots.of.sub.domains.foo.com/bar#baz', 'foo.com/bar#baz'

      testParseLinks 'https://www.foo.com', 'foo.com'
      testParseLinks 'ftp://www.foo.com', 'foo.com'
      testParseLinks 'future-protocol://www.foo.com', 'foo.com'

lots.of.sub.domains.com/wat/foo/bar#long-hash?query-etc&bar=roo&wat[]=f
lots.of.sub.domains.com/wat/foo/bar#lo...
Lorem ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum ipsum aa lots.of.sub.domains.com/wat/foo/bar#lo...

http://what.if.there.are.so.many.sub.domains.that.eventually.you.run.out.of.space.for.all.the.things.com/blahblahblahblahblahblahblahblahblahblahblahblahblahblahblahblahblahblahblahblahblahblahblahblahblahblahblahblahblahblah
n.out.of.space.for.all.the.things.com/blahblahblahbl…

n.out.of.space.for.all.the.things.com
