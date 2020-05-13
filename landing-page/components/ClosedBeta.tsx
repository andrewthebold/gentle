import styles from "./ClosedBeta.module.scss";

const ClosedBeta = () => (
  <a
    className={styles.warning}
    href="https://www.reddit.com/r/gentleapp/"
    target="_blank"
    rel="noopener noreferrer"
  >
    <span className={styles.title}>Notice</span>
    <br />
    Beta signup is closed as of April 19.
    <br />
    Follow updates on reddit at <span className={styles.link}>r/gentleapp</span>
    !
  </a>
);

export default ClosedBeta;
