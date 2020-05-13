import styles from "./Phone.module.scss";

const Phone = () => (
  <figure className={styles.phone}>
    <div className={styles.phoneBottom}></div>
    <iframe
      className={styles.phoneContent}
      src="#VIMEO_EMBED_LINK_REMOVED"
      width="324"
      height="660"
      frameBorder="0"
      allow="autoplay"
    ></iframe>

    <div className={styles.phoneTop}></div>
  </figure>
);

export default Phone;
