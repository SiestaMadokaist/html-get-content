require "./test/test_helper"
require "htmlparser"
RSpec.describe HTMLParser do
  context("on a raw string") do
    let(:raw){
      "
      hello world
      "
    }
    let(:html){ HTMLParser.new(raw) }
    describe(".content") do
      it("doesn`t really modify anything") do
        expect(html.content_string).to(include("hello world"))
      end
    end
  end

  context("on a simple html string") do
    let(:raw) do
      "
      <p>hello world</p>
      "
    end
    let(:html){ HTMLParser.new(raw) }
    describe(".content") do
      it("return the content") do
        expect(html.content_string).to(include("hello world"))
        expect(html.content_string).not_to(include("<p>"))
      end
    end
  end

  context("on a nested html string") do
    let(:raw) do
      "
      <body>
        <div> this is div </div>
        <div> this is another div </div>
        <div><div>this is another div inside div</div></div>
      </body>
      "
    end
    let(:html) { HTMLParser.new(raw) }
    describe(".content") do
      it("parse the content correctly") do
        expect(html.content_string).to(include("this is div"))
        expect(html.content_string).to(include("this is another div"))
        expect(html.content_string).to(include("this is another div inside div"))
        expect(html.content_string).not_to(include("<div>"))
        expect(html.content_string).not_to(include("</div>"))
      end
    end
  end

  context("on a complex html string") do
    let(:raw) do
      " this is outside the body lol
      <body background=\"#FFF000\">
        <div class='hello world'>
          this is inside hello world
        </div>
        <div class='hahaha'>
          this is inside another div that is not hello world
        </div>
        <span>non-empty SPAN</span>
        <span></span>
      </body>
      "
    end
    let(:html){ HTMLParser.new(raw) }
    describe(".content") do
      it("parse the content correctly") do
        expect(html.content_string).to(include("this is inside hello world"))
        expect(html.content_string).to(include("this is outside the body lol"))
        expect(html.content_string).to(include("this is inside another div"))
        expect(html.content_string).to(include("non-empty SPAN"))
        expect(html.content_string).not_to(include("span"))
      end
    end
  end
end
