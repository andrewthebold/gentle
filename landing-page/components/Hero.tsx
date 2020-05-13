import styles from "./Hero.module.scss";

import Phone from "./Phone";
import ShutdownCard from "./ShutdownCard";

const Hero = () => (
  <section className={styles.hero}>
    <div className={styles.heroContent}>
      <h1 className={styles.title}>
        Give and get kindness
        <br />
        on-the-go
      </h1>
      <p className={styles.description}>
        A social app to send and receive messages of compassion. Anonymous and
        safe.
      </p>
      <ShutdownCard />
      <p className={styles.updated}>Updated May 8, 2020</p>
    </div>
    <div className={styles.phoneWrapper}>
      <Phone />
    </div>
  </section>
);

export default Hero;
