import styles from "./PrivacyLetter.module.scss";

const PrivacyLetter = () => (
  <section className={styles.section}>
    <div className={styles.letter}>
      <div className={styles.attribution}>Gentle's</div>
      <h1>Privacy Policy</h1>
      <p>
        Gentle takes your privacy very seriously. Its developer{" "}
        <em>does not</em> want to collect identifying information and designs
        Gentle to avoid it wherever possible.
      </p>

      <h2>What we collect and why</h2>
      <ul>
        <li>
          <p>
            <strong>Account metadata</strong>: When you first use Gentle, an
            anonymous user account is created with a timestamp of when you
            started. This account is linked to your device.
          </p>
        </li>
        <li>
          <p>
            <strong>Feature-specific data</strong>: When you create content
            that's part of the core experience of the app (e.g., a request or
            reply), that data is stored in order to serve it to you and others.
          </p>
        </li>
        <li>
          <p>
            <strong>Support interactions</strong>: When you submit a report or
            email Gentle, a record is kept. This may include your email address,
            so that there is a history of past correspondences to reference if
            you reach out in the future.
          </p>
        </li>
        <li>
          <p>
            <strong>Analytics and Errors</strong>: We collect anonymized
            information about the behavior of app and website users, along with
            aggregate data about crashes. See{" "}
            <a href="#3rd-party">3rd party services used</a> for more info.
          </p>
        </li>
      </ul>

      <h2>Data Deletion</h2>
      <p>
        You have the ability to delete all data associated with your user
        account, with the exception of support interactions, analytics data, and
        crash logs.
      </p>

      <h2 id="3rd-party">3rd-party services used</h2>
      <ul>
        <li>
          <p>
            <a href="https://firebase.google.com/">Firebase</a> (
            <a href="https://firebase.google.com/support/privacy">
              Privacy Policy
            </a>
            ): Used to enable networked interactions in the app. Specifically,
            Firebase's Cloud Firestore and Authentication. Analytics features
            are disabled wherever possible.
          </p>
        </li>
        <li>
          <p>
            <a href="https://sentry.io/">Sentry</a> (
            <a href="https://sentry.io/privacy/">Privacy Policy</a>): Used to
            investigate app crashes and errors. Privacy features such as data
            scrubbing, not storing IP addresses, and more are enabled.
          </p>
        </li>
        <li>
          <p>
            <a href="https://simpleanalytics.com" target="_blank">
              Simple Analytics
            </a>{" "}
            (<a href="https://simpleanalytics.com/privacy">Privacy Policy</a>,{" "}
            <a href="https://docs.simpleanalytics.com/what-we-collect">
              What's Collected
            </a>
            ): Used to get basic information about the behavior of website
            visitors. It does not track visitors and does not store any personal
            identifiable information.
          </p>
        </li>
      </ul>

      <h2>Questions and Feedback</h2>
      <p>
        This privacy policy might change or be edited for clarity over time.
        Up-to-date information will always be available on this page.
      </p>
      <p>
        Please <a href="mailto:EMAIL_REMOVED">send an email</a> if you have any
        questions about Gentle's data collection or privacy policies.
      </p>
      <div className={styles.attributionEnd}>Last updated: April 13, 2020</div>
    </div>
  </section>
);

export default PrivacyLetter;
