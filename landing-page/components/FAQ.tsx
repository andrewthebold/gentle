import styles from "./FAQ.module.scss";
import PageWrapper from "./PageWrapper";
import Link from "next/link";

const FAQ = () => (
  <section className={styles.section}>
    <PageWrapper>
      <h2>FAQ</h2>
      <div className={styles.items}>
        <div>
          <details>
            <summary>tl;dr: What is Gentle?</summary>
            <ol>
              <li>It's a mobile app.</li>
              <li>
                You anonymously write requests about things you're worried
                about.
              </li>
              <li>
                Other people can reply to your requests with kindness and
                compassion.
              </li>
              <li>You can reply to others' requests too.</li>
              <li>
                The app has spam and bad word filters, and reports are taken
                seriously.
              </li>
            </ol>
          </details>
          <details>
            <summary>Is this app meant to solve my problems?</summary>
            <p>
              It’s tempting to think Gentle is about solving your deepest
              problems, but that’s not the goal. One of the expectations you
              agree to when you start is &ldquo;I recognize I can’t fix others’
              problems, but I can share kindness.&rdquo;
            </p>
            <p>
              If there <em>is</em> a &ldquo;goal&rdquo; in this app, it's to
              take the reflection and empathy it encourages into other parts of
              your life.
            </p>
            <p>
              It's important to note that Gentle is not a replacement for
              counseling. If anything, I hope it will encourage people to seek
              out professional support when it's helpful.
            </p>
          </details>
          <details>
            <summary>
              Were you inspired by games like <em>Kind Words</em>?
            </summary>
            <p>
              Absolutely, yes!{" "}
              <a
                href="http://popcannibal.com/kindwords/"
                target="_blank"
                rel="noopener noreferrer"
              >
                Kind Words
              </a>
              ,{" "}
              <a
                href="https://animal-crossing.com/"
                target="_blank"
                rel="noopener noreferrer"
              >
                Animal Crossing
              </a>
              ,{" "}
              <a
                href="http://ashorthike.com/"
                target="_blank"
                rel="noopener noreferrer"
              >
                A Short Hike
              </a>
              ,{" "}
              <a
                href="https://www.getslowly.com/en/"
                target="_blank"
                rel="noopener noreferrer"
              >
                Slowly
              </a>
              ,{" "}
              <a
                href="https://www.youtube.com/watch?v=5qap5aO4i9A"
                target="_blank"
                rel="noopener noreferrer"
              >
                lo-fi hip hop radio
              </a>
              , and many more. There's been a growing appetite for experiences
              that inject kind feels into your life. I'd argue there's nothing
              novel here beyond my own take on the genre. The closest thing I've
              worked on is a conversation tool called{" "}
              <a
                href="https://supportive.app/"
                target="_blank"
                rel="noopener noreferrer"
              >
                Supportive
              </a>
              .
            </p>
            <p>
              Gentle was designed to be a cute and delightful experience. I hope
              you find something wonderful on it!
            </p>
          </details>
          <details>
            <summary>How do you keep the app safe?</summary>
            <ul>
              <li>At official launch, Gentle will be a paid app.</li>
              <li>
                We moderate the content and provide easy-to-use reporting tools.
              </li>
              <li>We use spam and bad word filters.</li>
              <li>
                We timeout or ban users who repeatedly or flagrantly break our
                rules.
              </li>
              <li>
                Personally identifying information is banned from any messages.
              </li>
              <li>All new users agree to community expectations.</li>
              <li>
                (Soon) We'll offer guides and tips for writing excellent
                messages.
              </li>
              <li>
                (Soon) If the app notices that somebody is writing about
                concerning topics like self-harm, it will privately and
                proactively offer resources from professionals.
              </li>
            </ul>
          </details>
          <details>
            <summary>What's the roadmap?</summary>
            <p>
              There's lots of ideas brewing. If you have any ideas,{" "}
              <a href="mailto:#EMAIL_REMOVED">reach out and share it!</a>
            </p>
            <ul>
              <li>Stickers, letter styles, new envelopes, and more</li>
              <li>Formal community and moderation guidelines</li>
              <li>
                Replying more than once to someone (could be chatting, 1-time
                replies, etc.)
              </li>
              <li>Dark mode and accessibility fixes</li>
              <li>Non-addictive push notifications</li>
              <li>Ability to login to sync data across devices</li>
              <li>Collectables and a place to keep them</li>
              <li>Messages in a bottle?</li>
              <li>And many more...!</li>
              <p>
                You can follow a more specific roadmap on this{" "}
                <a
                  href="#TRELLO_LINK_REMOVED"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  this Trello board
                </a>
                .
              </p>
            </ul>
          </details>
        </div>
        <div>
          <details>
            <summary>How does Gentle make money?</summary>
            <p>Gentle will be a paid app. There are no ads.</p>
            <p>
              A positive byproduct of being a paid app is ensuring that Gentle
              is moderated well.
            </p>
            <p>
              There may be future in-app purchases for cosmetics (such as
              envelope types, stickers, and more). However, the plan is to
              provide a hefty amount of cosmetics by default.
            </p>
          </details>
          <details>
            <summary>Why should I trust Gentle?</summary>
            <ul>
              <li>
                If you trust{" "}
                <a
                  href="https://andrewlee.design/"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  me
                </a>
                , the creator and moderator of Gentle. Previously, I worked in
                the Privacy org at Facebook, which I’m sure will spook some
                people. Today, I work at Khan Academy as a designer.
              </li>
              <li>
                If you are comfortable with the design choices in this app. The
                anonymous nature of the app lends it to be more difficult to
                connect things to who you are. You are also able to push the
                &ldquo;eject&rdquo; button at anytime and delete your stuff.
              </li>
              <li>
                If you are comfortable with your device communicating with
                Google's Firebase, which is used as the server, and Sentry.io,
                which is used as a crash log.
              </li>
            </ul>
          </details>
          <details>
            <summary>Do you read my messages?</summary>
            <p>
              <strong>
                I will only read something you wrote if it is reported by
                someone.
              </strong>
            </p>
            <p>
              This is a flimsy guarantee based on trust. If I become corrupt, I
              hope you hold me accountable by complaining loudly and deleting
              the app.
            </p>
            <p>
              Because Gentle is not encrypted, I <em>do</em> have the ability to
              read the messages you send. However, because this app is anonymous
              and it doesn't collect personal data, it's likely impossible to
              identify who you are.
            </p>
            <p>
              In the future, I’m interested in encrypting replies so that it
              becomes infeasible to read messages. However, this will depend on
              whether it’s seen as a valuable investment by the community.
            </p>
          </details>
          <details>
            <summary>Do you collect or sell personal data?</summary>
            <p>
              No! I have no interest in collecting the details of your life or
              sharing it with anyone. See Gentle's{" "}
              <Link href="/privacy">
                <a>Privacy Policy</a>
              </Link>{" "}
              to learn about the minimal data we store.
            </p>
            <p>
              Please don't send identifying information in this app. This
              includes names, pseudonyms, addresses, emails, telephone numbers,
              locations, and more.
            </p>
          </details>
          <details>
            <summary>Android version?</summary>
            <p>
              Gentle is no longer live, but an Android version was planned. The
              app was built with a cross-platform framework called Flutter, so
              it would be quite easy to get an Android version ready.
            </p>
          </details>
        </div>
      </div>
    </PageWrapper>
  </section>
);

export default FAQ;
