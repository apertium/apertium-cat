node {
   stage 'Checkout'
   checkout scm

   stage 'Build'
   sh "./autogen.sh && ./configure && make"

   stage 'Validate Dictionary (dix)'
   sh "apertium-validate-dictionary apertium-cat-cat.dix"

   stage 'Validate Tagger Specification (tsx)'
   sh "apertium-validate-tagger apertium-cat-cat.tsx"
}
