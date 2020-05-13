import styles from "./ShutdownCard.module.scss";
import Link from "next/link";

const ShutdownCard = () => (
  <Link href="/shutdown">
    <a className={styles.warning}>
      <span className={styles.title}>Notice</span>
      <br />
      Gentle is shutting down on May 15, 5pm PST.
      <br />
      Learn more in <span className={styles.link}>this post</span>!
    </a>
  </Link>
);

export default ShutdownCard;
