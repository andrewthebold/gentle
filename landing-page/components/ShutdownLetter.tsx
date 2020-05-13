import styles from "./ShutdownLetter.module.scss";

const ShutdownLetter = () => (
  <section className={styles.section}>
    <div className={styles.letter}>
      <article>
        <div className={styles.banner}></div>
        <header>
          <h1>A Gentle Farewell</h1>
          <p className={styles.tagline}>
            Gentle is shutting down on May 15, 5pm PST.
            <br />
            The project's source code will be released.
          </p>
        </header>
        <p>
          Heyo! I'm{" "}
          <a
            href="https://andrewlee.design/"
            target="_blank"
            rel="noopener noreferrer"
          >
            Andrew
          </a>
          , the creator of Gentle. If you're not familiar, Gentle is a mobile
          app where you write requests for kindness and reply to others. It's
          cute, anonymous, and moderated. It's been my side project for three
          months.
        </p>
        <p>
          In the past few weeks, around 6,000 people have joined Gentle's iOS
          beta. It's been a privilege to have so much interest, praise, and
          support for my work. I got lucky with the beta launch (see{" "}
          <a
            href="https://news.ycombinator.com/item?id=22909419"
            target="_blank"
            rel="noopener noreferrer"
          >
            HN
          </a>{" "}
          and{" "}
          <a
            href="https://www.reddit.com/r/apple/comments/g3qrkj/gentle_is_a_social_app_where_you_give_and_get/"
            target="_blank"
            rel="noopener noreferrer"
          >
            reddit
          </a>
          ) and I'm so grateful. I don't take it lightly that I've received lots
          of mail like this:
        </p>
        <RequestStack />
        <h2>Unfortunately, I've decided to stop working on Gentle</h2>
        <p>
          What on earth happened? To be transparent: I realized that I can't
          commit the time and effort to keep Gentle going. There are a few
          reasons:
        </p>
        <ol>
          <li>
            <p>
              The pandemic has convinced me to prioritize my full-time job. I
              believe it's where I can do the most good right now.
            </p>
          </li>
          <li>
            <p>
              Moderation has taken a toll on my well-being, and I don't have
              time to commit to community building.
            </p>
          </li>
          <li>
            <p>
              I've had some personal happenings that need my attention more.
            </p>
          </li>
        </ol>
        <p>
          I'm sorry to anybody disappointed by my decision. I hope you
          understand. 🙏
        </p>
        <h2>What will happen to Gentle?</h2>
        <p>
          Bringing in helpers isn't a solution because I'm not available to
          coordinate it. I'm also not interested in selling Gentle.
        </p>
        <p>
          I've decided to shut down the beta and release the source code for the
          project. This includes the Flutter app, Firebase server code,
          moderation dashboard, landing page, and my{" "}
          <a
            href="https://www.reddit.com/r/gentleapp/comments/g6btp8/what_it_looks_like_to_design_gentle/"
            target="_blank"
            rel="noopener noreferrer"
          >
            design files in Figma
          </a>
          .
        </p>
        <p>
          Sharing the project's files is no substitute for keeping it going (or
          maintaining it as open-source), but I hope it inspires you. Remix it.
          Take its parts. Build things that bring kindness into the world,
          because we sure need more of it.
        </p>
        <p className={styles.edit}>
          <span>
            ✏️ Edit <span>May 10</span>
          </span>
          In case somebody decides to fork Gentle or start something new like
          it, a good place to follow might be the subreddit{" "}
          <a
            href="https://www.reddit.com/r/gentleapp/"
            target="_blank"
            rel="noopener noreferrer"
          >
            r/gentleapp
          </a>
          !
        </p>
        <div className={styles.shutdownBlock}>
          <h2>Timeline of shutdown</h2>
          <div className={styles.shutdownPill}>
            May 8 <span>Time of publication</span>
          </div>
          <ul>
            <li>
              <p>
                Version 0.1.0+8 of Gentle is available to beta testers with the
                ability to export your messages via email and clipboard.
              </p>
            </li>
            <li>
              <p>New TestFlight beta signups are closed.</p>
            </li>
          </ul>
          <div className={styles.shutdownPill}>
            May 10 <span>10pm PST</span>
          </div>
          <ul>
            <li>
              <p>
                You will no longer be able to send messages on the app. You'll
                get an error when you try.
              </p>
            </li>
          </ul>
          <div className={styles.shutdownPill}>
            May 15 <span>5pm PST</span>
          </div>
          <ul>
            <li>
              <p>
                All server data will be deleted, and you will no longer be able
                to access or export your messages.
              </p>
            </li>
            <li>
              <p>The TestFlight beta group for Gentle will be deleted.</p>
            </li>
            <li>
              <p>All Gentle codebases will be released under an MIT license.</p>
            </li>
            <li>
              <p>
                The master Figma file for Gentle will be shared, freely
                available.
              </p>
            </li>
          </ul>
          <div className={styles.shutdownPill}>
            The Future <span>Soon!</span>
          </div>
          <ul>
            <li>
              <p>
                Products like (and inspired by) Gentle will contribute to a
                generation of more compassionate people.
              </p>
            </li>
            <li>
              <p>
                You'll have a lot of fulfilling days and memorable experiences.
              </p>
            </li>
          </ul>
        </div>
        <hr />
        <p>
          If you're interested in my future projects, you can follow me at{" "}
          <a
            href="https://www.twitter.com/andrewthebold"
            target="_blank"
            rel="noopener noreferrer"
          >
            @andrewthebold
          </a>{" "}
          or reach me directly at{" "}
          <a
            href="mailto:hi@andrewlee.design"
            target="_blank"
            rel="noopener noreferrer"
          >
            hi@andrewlee.design
          </a>{" "}
          ✨
        </p>
        <p>
          <time>Updated May 10, 2020</time>
        </p>
      </article>
    </div>
  </section>
);

const RequestStack = () => (
  <div className={styles.requestStack}>
    <Request
      className={styles["request--1"]}
      text="I just answered a few letters and it felt so good and special. I
      feel needed and connected once again."
    />
    <Request
      className={styles["request--2"]}
      text="You've already contributed a serious net positive to the world with this beta."
    />
    <Request
      className={styles["request--3"]}
      text="I love this app and it has a huuuuge potential."
    />
  </div>
);

interface RequestProps {
  text: string;
  className: string;
}

const Request = (props: RequestProps) => (
  <div className={[styles.request, props.className].join(" ")}>
    <p>{props.text}</p>
  </div>
);

const EnvelopeStack = () => (
  <div className={styles.envelopeStack}>
    <img
      className={styles.envelopeOfficial}
      src="/images/envelope_official.svg"
      alt="Official envelope"
    />
    <img
      className={styles.envelopePlain}
      src="/images/envelope_plain.svg"
      alt="Plain envelope"
    />
    <img
      className={styles.envelopeAirmail}
      src="/images/envelope_airmail.svg"
      alt="Airmail envelope"
    />
  </div>
);

export default ShutdownLetter;
