import Head from "next/head";
import Header from "../components/Header";
import PageWrapper from "../components/PageWrapper";
import Footer from "../components/Footer";
import PrivacyLetter from "../components/PrivacyLetter";

const Privacy = () => (
  <>
    <Head>
      <title key="title">Gentle: Privacy Policy</title>
    </Head>

    <PageWrapper>
      <Header />
    </PageWrapper>

    <main>
      <PageWrapper>
        <PrivacyLetter />
      </PageWrapper>
    </main>

    <PageWrapper>
      <Footer />
    </PageWrapper>
  </>
);

export default Privacy;
