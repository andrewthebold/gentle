import styles from "./Explanations.module.scss";
import ExplainHeader, { ExplainIcon } from "./ExplainHeader";

const Explanations = () => (
  <section className={styles.wrapper}>
    <div className={styles.section}>
      <ExplainHeader
        icon={ExplainIcon.airplane}
        text="Write a request for kindness"
      />
      <RequestStack />
    </div>
    <div className={styles.section}>
      <ExplainHeader
        icon={ExplainIcon.reply}
        text="Send and receive kind replies"
      />
      <EnvelopeStack />
    </div>
    <div className={styles.section}>
      <ExplainHeader icon={ExplainIcon.shield} text="Moderated and anonymous" />
      <ul className={styles.list}>
        <li className={styles.listStamp}>Spam and bad word filters</li>
        <li className={styles.listRabbit}>Reporting and moderation</li>
        <li className={styles.listLock}>No ads or data selling</li>
        <li className={styles.listTrash}>Delete everything, anytime</li>
      </ul>
    </div>
  </section>
);

const RequestStack = () => (
  <div className={styles.requestStack}>
    <Request
      className={styles["request--1"]}
      text="There have been a lot of changes in my life lately..."
    />
    <Request
      className={styles["request--2"]}
      text="I've been feeling pretty anxious about..."
    />
    <Request
      className={styles["request--3"]}
      text="It feels like my friends have a different..."
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

export default Explanations;
