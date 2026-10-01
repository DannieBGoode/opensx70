require "test_helper"
require File.join(ROOT, "_plugins/html_truncate")

class HtmlTruncateTest < Minitest::Test
  include OpenSX70HtmlTruncate

  def test_leaves_short_content_untouched
    assert_equal "<p>a b</p>", truncate_html_words("<p>a b</p>", 5)
  end

  def test_truncates_text_and_closes_open_tags
    assert_equal "<p>one two...</p>", truncate_html_words("<p>one two three</p><p>four</p>", 2)
  end

  def test_does_not_count_or_split_attribute_words
    image = %(<img src="/x.jpg" alt="many words in the alt text" title="more words">)
    input = "<p>Hi</p><p>#{image}</p><p>a b c</p>"

    assert_equal "<p>Hi</p><p>#{image}</p><p>a b...</p>", truncate_html_words(input, 3)
  end

  def test_closes_nested_tags_in_order
    assert_equal "<p><em>a b...</em></p>", truncate_html_words("<p><em>a b c</em> d</p>", 2)
  end

  def test_void_elements_are_not_closed
    assert_equal "<p>a<br>b...</p>", truncate_html_words("<p>a<br>b c</p>", 2)
  end

  def test_handles_nil
    assert_equal "", truncate_html_words(nil, 5)
  end

  # Value: protects=word budget at exactly the limit; fails_when=`text_words <= remaining` becomes `<` and posts of exactly N words get a spurious ellipsis; why_new=existing cases are all under or over the limit, never on it; seam=none
  def test_content_with_exactly_limit_words_has_no_ellipsis
    assert_equal "<p>a b</p>", truncate_html_words("<p>a b</p>", 2)
  end

  # Value: protects=open-tag stack when a post has a stray closing tag; fails_when=the `if index` guard is dropped (slice!(nil..) clears the stack) or closing tags get pushed, leaving the preview's <p>/<div> unclosed or double-closed; why_new=no existing case has a closing tag without a matching open; seam=none
  def test_stray_closing_tag_keeps_outer_tags_tracked
    assert_equal "<div><p>a</span> b...</p></div>", truncate_html_words("<div><p>a</span> b c</p></div>", 2)
  end

  # Value: protects=HTML comments in real posts (<!--StartFragment--> in the 2023 Dolores posts); fails_when=tag-name extraction stops requiring a letter, so a comment is pushed and emitted as a bogus closing tag, or comment text is counted as words; why_new=no existing case contains a comment token; seam=none
  def test_comments_are_kept_but_not_counted_or_closed
    assert_equal "<!--StartFragment--><p>a b...</p>", truncate_html_words("<!--StartFragment--><p>a b c</p>", 2)
  end

  # Value: protects=previews stop once the word budget is spent; fails_when=media after the last counted word (a gallery) is still emitted until the next text node; why_new=exact-limit case only covers inputs that end at the limit; seam=none
  def test_content_after_spent_budget_is_cut
    assert_equal "<p>a b...</p>", truncate_html_words(%(<p>a b</p><img src="/x.jpg"><p>c</p>), 2)
  end

  # Value: protects=listing markup when an excerpt leaves a tag open; fails_when=under-limit input is returned with unclosed tags and wraps every later post card; why_new=all other cases are balanced; seam=none
  def test_closes_tags_left_open_under_the_limit
    assert_equal "<div><p>a</p></div>", truncate_html_words("<div><p>a</p>", 5)
  end

  # Value: protects=commented-out HTML in a post; fails_when=a comment containing ">" is split, its words counted, and an unterminated <!-- hides the rest of the listing; why_new=the existing comment case has no ">" inside; seam=none
  def test_comments_with_markup_inside_are_opaque
    input = "<p>one two</p><!-- <p>a b c d e f</p> --><p>three four five</p>"

    assert_equal "<p>one two</p><!-- <p>a b c d e f</p> --><p>three...</p>", truncate_html_words(input, 3)
  end

  # Value: protects=embedded scripts (tweet/video embeds); fails_when=script text is counted as words or cut mid-code; why_new=no case covers raw-text elements; seam=none
  def test_script_blocks_are_not_counted_or_cut
    input = "<p>a <script>if (x < 2) { y() }</script> b c</p>"

    assert_equal "<p>a <script>if (x < 2) { y() }</script> b...</p>", truncate_html_words(input, 2)
  end

  # Value: protects=raw-HTML attributes containing ">" or a trailing "/"; fails_when=a quoted ">" splits the tag or href=/x/ is treated as self-closing and the <a> is never closed; why_new=existing tags have simple attributes; seam=none
  def test_attribute_edge_cases_keep_tags_intact
    assert_equal %(<p><img alt="x > y" src="/a.jpg"> one...</p>), truncate_html_words(%(<p><img alt="x > y" src="/a.jpg"> one two</p>), 1)
    assert_equal "<a href=/foo/>one...</a>", truncate_html_words("<a href=/foo/>one two</a>", 1)
  end

  # Value: protects=word counting on pasted content; fails_when=a stray "<" opens a phantom tag or &nbsp; counts as a word; why_new=no case covers either; seam=none
  def test_stray_less_than_and_nbsp_are_text
    assert_equal "<p>a < b...</p>", truncate_html_words("<p>a < b c</p>", 3)
    assert_equal "<p>\u00A0a b...</p>", truncate_html_words("<p>\u00A0a b c</p>", 2)
  end

  # Value: protects=homepage preview links stay one link per card; fails_when=links inside a post survive into the preview and nest inside the card link (browser closes it early: empty link, unclickable text); why_new=no case covers anchors; seam=none
  def test_strip_links_keeps_link_text
    input = %(<p>Meet <a href="https://opensx70.com/x" title="a > b">Loli</a> and <A HREF='/y'>Dolores</A></p>)

    assert_equal "<p>Meet Loli and Dolores</p>", strip_links(input)
  end
end
