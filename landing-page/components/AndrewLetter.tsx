import styles from "./AndrewLetter.module.scss";

const AndrewLetter = () => (
  <section className={styles.section}>
    <div className={styles.letter}>
      <div className={styles.attribution}>Heyo!</div>
      <p>
        My name is{" "}
        <a
          href="https://andrewlee.design/"
          target="_blank"
          rel="noopener noreferrer"
        >
          Andrew
        </a>
        , and I’m the solo maker of this app. Pleasure!
      </p>
      <p>
        I’m making Gentle because I think people have such a capacity for
        kindness, but they don't often get the chance to flex that muscle
        online. The big social media platforms of today aren’t designed to
        spread love and empowerment. In fact, they’re often incentivized to do
        the exact opposite. It's disheartening because I believe there’s so much
        potential in digital connection.
      </p>
      <p>
        With Gentle, I hope to give you a place that’s worthy of your time and
        grows the compassion in your life. If it’s not for you, you have the
        control to easily delete all of your data and try something else.
      </p>
      <p>
        Whether you hate it, love it, or have questions,{" "}
        <a
          href="mailto:#EMAIL_REMOVED"
          target="_blank"
          rel="noopener noreferrer"
        >
          reach out to me directly
        </a>{" "}
        and I’ll follow up with haste!
      </p>
      <div className={styles.attributionEnd}>Best, Andrew</div>
      <img
        className={styles.avatar}
        srcSet="/images/andrew.png,
                /images/andrew@2x.png 2x"
        src="/images/andrew.png"
        alt="Avatar of Andrew"
      />
    </div>
  </section>
);

export default AndrewLetter;
