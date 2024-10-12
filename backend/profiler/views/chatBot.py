import time
from datetime import datetime
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from profiler.serializations.chatBot import GenAIResponseSerializer
from dotenv import load_dotenv
import google.generativeai as genai
import os

load_dotenv()

genai.configure(api_key=os.getenv("GEMINI_API_KEY"))


class ChatBotAPIView(APIView):
    def post(self, request):
        input_text = request.data.get('input', '')
        history = request.data.get('history', [])

        history_text = ""
        for i in history:
            history_text += str(i) + ","

        query = history_text + "New query : " + input_text
        start_time = time.time()

        model = genai.GenerativeModel("gemini-1.5-flash")
        output_response = model.generate_content(query)
        processing_time = time.time() - start_time

        output_text = ""
        if output_response._done and output_response._result.candidates:
            output_text = output_response._result.candidates[0].content.parts[0].text

        response_data = {
            'input': input_text,
            'output': output_text,
            'timestamp': datetime.now(),
            'processing_time': processing_time,
        }

        serializer = GenAIResponseSerializer(data=response_data)

        if serializer.is_valid():
            return Response(serializer.data, status=status.HTTP_200_OK)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
