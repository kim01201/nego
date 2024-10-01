package com.itbank.mavenNego;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.util.HtmlUtils;

import com.google.gson.Gson;
import com.itbank.mavenNego.dto.ChatMessageDTO;
import com.itbank.mavenNego.dto.ChatRoomDTO;
import com.itbank.mavenNego.dto.MemberDTO;
import com.itbank.mavenNego.dto.ProductDTO;
import com.itbank.mavenNego.service.ChatService;
import com.itbank.mavenNego.service.ChatRoomService;
import com.itbank.mavenNego.service.MemberMapper;
import com.itbank.mavenNego.service.ProductMapper;

@Controller
public class ChatController {

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @Autowired
    private ProductMapper productMapper;

    @Autowired
    private ChatService chatService;

    @Autowired
    private ChatRoomService chatRoomService;

    @Autowired
    private MemberMapper memberMapper;

    @MessageMapping("/Nego/chat/send")
    @SendTo("/topic/messages")
    @GetMapping("/chatPage.do")
    public String chatPage(@RequestParam("room_Id") String roomId, Model model) {
        System.out.println("Received room_Id: " + roomId);
        List<ChatMessageDTO> messages = chatService.getMessagesByRoomId(roomId);
        model.addAttribute("messages", messages);
        model.addAttribute("room_Id", roomId);

        int pnum = chatService.getPnumByRoomId(roomId);
        String receiverId = chatService.getReceiverIdByPnum(pnum);
        model.addAttribute("pnum", pnum);
        model.addAttribute("receiver_Id", receiverId);

        return "nego/chat/chatPage";
    }

    @GetMapping("/getProductForChatHeader")
    @ResponseBody
    public ResponseEntity<?> getProductForChatHeader(@RequestParam("pnum") int pnum) {
        try {
            ProductDTO product = productMapper.getProd(pnum);
            if (product == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Product not found");
            }

            MemberDTO member = memberMapper.getMember(product.getMember_id());
            if (member == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Member not found");
            }

            Map<String, Object> response = new HashMap<>();
            response.put("product", product);
            response.put("member", member);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error retrieving product or member");
        }
    }

    @GetMapping("/sendChatToSeller")
    @ResponseBody
    public ResponseEntity<String> sendChatToSeller(@RequestParam("seller_id") String sellerId, @RequestParam("message") String message) {
        try {
            String sellerTopic = "/topic/messages/" + sellerId;
            messagingTemplate.convertAndSend(sellerTopic, message);
            return ResponseEntity.ok("Message sent successfully to seller");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error sending message to seller");
        }
    }

    @MessageMapping("/chat")
    public void sendMessage(ChatMessageDTO message) {
        System.out.println("Received message: " + message);

        if (message.getRoom_Id() == null || message.getRoom_Id().isEmpty()) {
            throw new IllegalArgumentException("room_Id must not be null or empty");
        }

        if (message.getMessage_Id() == null || message.getMessage_Id().isEmpty()) {
            String generatedMessageId = UUID.randomUUID().toString();
            message.setMessage_Id(generatedMessageId);
            System.out.println("Generated messageId: " + generatedMessageId);
        }

        try {
            ChatRoomDTO chatRoom = chatRoomService.getChatRoomById(message.getRoom_Id());
            if (chatRoom == null) {
                chatRoom = new ChatRoomDTO();
                chatRoom.setRoomId(message.getRoom_Id());
                chatRoomService.createChatRoom(message.getPnum(), message.getSender_Id(), message.getReceiver_Id());
            }

            MemberDTO sender = memberMapper.getMember(message.getSender_Id());
            if (sender == null) {
                sender = new MemberDTO();
                sender.setId(message.getSender_Id());
                sender.setPasswd("defaultPassword");
                sender.setName("defaultName");
                sender.setSsn1("000000");
                sender.setSsn2("0000000");
                sender.setEmail("defaultEmail@example.com");
                sender.setHp1("010");
                sender.setHp2("0000");
                sender.setHp3("0000");
                sender.setAddr("defaultAddress");
                memberMapper.saveMember(sender);
                System.out.println("Created new sender: " + sender);
            }

            chatService.saveMessage(message);
            messagingTemplate.convertAndSend("/topic/messages/" + message.getRoom_Id(), message);
        } catch (Exception e) {
            System.err.println("Failed to save message: " + e.getMessage());
        }
    }


    @RequestMapping(value = "/headerChatRooms.do", method = RequestMethod.GET, produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String headerChatRooms() {
        System.out.println("Fetching chat rooms for header...");
        List<ChatRoomDTO> chatRooms = chatRoomService.getChatRooms();
        String chatRoomsJson = new Gson().toJson(chatRooms);
        System.out.println("Chat rooms in header: " + chatRoomsJson);
        return chatRoomsJson;
    }

    @RequestMapping(value = "/createChatRoom.do", method = RequestMethod.POST)
    @ResponseBody
    public String createChatRoom(@RequestParam("roomName") String roomName) {
        ChatRoomDTO chatRoom = new ChatRoomDTO();
        chatRoom.setRoomId(UUID.randomUUID().toString());
        chatRoomService.createChatRoom(chatRoom.getPnum(), "sellerId", "buyerId");
        return new Gson().toJson(chatRoom);
    }

    @RequestMapping(value = "/getChatMessages.do", method = RequestMethod.GET)
    @ResponseBody
    public List<ChatMessageDTO> getChatMessages(@RequestParam("room_Id") String roomId) {
        System.out.println("Fetching messages for room ID: " + roomId);
        return chatService.getMessagesByRoomId(roomId);
    }

    @GetMapping("/chatRoomDetails.do")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getChatRoomDetails(@RequestParam("room_Id") String roomId) {
        Map<String, Object> response = new HashMap<>();
        response.put("room_Id", roomId);

        ProductDTO product = productMapper.getProdByRoomId(roomId);
        if (product != null) {
            response.put("imageUrl", product.getPimage());
            response.put("productName", product.getPname());
            response.put("price", product.getPrice() + "원");
        } else {
            response.put("imageUrl", "path/to/default/image.jpg");
            response.put("productName", "Default Product Name");
            response.put("price", "0원");
        }

        List<ChatMessageDTO> messages = chatService.getMessagesByRoomId(roomId);
        response.put("chatMessages", messages); // 전체 메시지 객체를 포함

        try {
            Integer pnum = chatService.getPnumByRoomId(roomId);
            if (pnum != null) {
                String receiverId = chatService.getReceiverIdByPnum(pnum);
                response.put("pnum", pnum);
                response.put("receiver_Id", receiverId);
                List<ChatMessageDTO> senderId = chatService.getByPnum(pnum);
                response.put("sender_id", senderId);
            } else {
                response.put("pnum", "Not found");
                response.put("receiver_Id", "Not found");
            }
        } catch (Exception e) {
            System.err.println("Error fetching pnum or receiver_Id: " + e.getMessage());
        }

        return ResponseEntity.ok(response);
    }
}
