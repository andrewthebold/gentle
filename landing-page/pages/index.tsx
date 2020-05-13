import Head from "next/head";
import Header from "../components/Header";
import PageWrapper from "../components/PageWrapper";
import Hero from "../components/Hero";
import FAQ from "../components/FAQ";
import Explanations from "../components/Explanations";
import AndrewLetter from "../components/AndrewLetter";
import Footer from "../components/Footer";

const Home = () => (
  <>
    <Head>
      <title key="title">Gentle: A social app for compassion</title>
      <link rel="canonical" href="<DOMAIN_REMOVED>" />
    </Head>

    <PageWrapper>
      <Header />
    </PageWrapper>

    <main>
      <PageWrapper>
        <Hero />
      </PageWrapper>
      <PageWrapper>
        <Explanations />
      </PageWrapper>
      <FAQ />
      <PageWrapper>
        <AndrewLetter />
      </PageWrapper>
    </main>

    <PageWrapper>
      <Footer />
    </PageWrapper>
  </>
);

export default Home;
