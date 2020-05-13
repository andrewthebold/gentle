import Head from "next/head";
import Header from "../components/Header";
import PageWrapper from "../components/PageWrapper";
import Footer from "../components/Footer";
import TermsLetter from "../components/TermsLetter";

const Privacy = () => (
  <>
    <Head>
      <title key="title">Gentle: Terms of Service</title>
    </Head>

    <PageWrapper>
      <Header />
    </PageWrapper>

    <main>
      <PageWrapper>
        <TermsLetter />
      </PageWrapper>
    </main>

    <PageWrapper>
      <Footer />
    </PageWrapper>
  </>
);

export default Privacy;
